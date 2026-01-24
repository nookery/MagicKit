import Combine
import Foundation
import OSLog
import SwiftUI

/// 全局下载进度监控器
///
/// 集中管理所有文件的下载进度监听，避免每个视图创建独立的监听器。
/// 使用单例模式和引用计数，确保每个 URL 只有一个监听器，当没有视图订阅时自动清理。
///
/// ## 优化说明
/// - 不使用 NSMetadataQuery，使用轻量级的 resourceValues 查询
/// - 已下载的文件不创建监听器，直接返回进度 1.0
/// - 使用轮询机制，每秒检查一次文件状态
/// - 将非 UI 操作移到后台线程执行，避免阻塞主线程
public final class AvatarDownloadMonitor: SuperLog {
    public static let emoji = "📥"

    /// 单例实例
    public static let shared = AvatarDownloadMonitor()

    /// 专门用于处理 MetadataQuery 更新的后台队列
    private static let processingQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "com.magickit.avatardownload.processing"
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        return queue
    }()

    /// 监听器信息
    private struct MonitorInfo {
        let publisher: CurrentValueSubject<Double, Never>
        var refCount: Int
        /// 用于取消监听的任务
        var monitorTask: Task<Void, Never>?
    }

    /// 监听器字典 [URL: MonitorInfo] - 使用 actor 确保线程安全
    private actor MonitorStore {
        var monitors: [URL: MonitorInfo] = [:]
        var activeMonitorCount: Int = 0

        func get(_ url: URL) -> MonitorInfo? {
            monitors[url]
        }

        func set(_ info: MonitorInfo, for url: URL) {
            monitors[url] = info
            activeMonitorCount = monitors.count
        }

        func remove(_ url: URL) -> MonitorInfo? {
            let removed = monitors.removeValue(forKey: url)
            activeMonitorCount = monitors.count
            return removed
        }

        /// 更新引用计数的结果
        enum RefCountUpdateResult {
            /// 监听器不存在
            case notFound
            /// 监听器仍在使用中（引用计数 > 0）
            case inUse(info: MonitorInfo, count: Int)
            /// 监听器已被移除（引用计数归零）
            case removed(removedInfo: MonitorInfo, count: Int)
        }

        func updateRefCount(for url: URL, increment: Bool) -> RefCountUpdateResult {
            guard var info = monitors[url] else {
                return .notFound
            }

            if increment {
                info.refCount += 1
                monitors[url] = info
                activeMonitorCount = monitors.count
                return .inUse(info: info, count: monitors.count)
            } else {
                info.refCount -= 1

                if info.refCount <= 0 {
                    // 引用计数归零，移除监听器
                    monitors.removeValue(forKey: url)
                    activeMonitorCount = monitors.count
                    return .removed(removedInfo: info, count: monitors.count)
                } else {
                    // 仍有其他订阅者
                    monitors[url] = info
                    return .inUse(info: info, count: monitors.count)
                }
            }
        }

        func getActiveCount() -> Int {
            activeMonitorCount
        }

        /// 获取所有活跃的监听器 URL
        func getActiveMonitors() -> [(url: URL, refCount: Int)] {
            monitors.map { ($0.key, $0.value.refCount) }
                .sorted { $0.refCount > $1.refCount }
        }
    }

    /// 线程安全的存储
    private let store = MonitorStore()

    /// 主线程上的活跃监听器数量（用于 UI 观察）
    @MainActor
    public private(set) var activeMonitorCount: Int = 0

    /// 订阅指定 URL 的下载进度
    ///
    /// 如果该 URL 已有监听器，增加引用计数并返回现有发布者。
    /// 如果没有，创建新的监听器并开始监控。
    ///
    /// - Parameter url: 要监听的文件 URL
    /// - Returns: 进度发布者，发送 0-1 之间的值
    public func subscribe(url: URL, verbose: Bool) async -> AnyPublisher<Double, Never> {
        // 检查是否已存在监听器
        if let existing = await store.get(url) {
            // 已存在，增加引用计数
            let result = await store.updateRefCount(for: url, increment: true)

            // 更新主线程上的计数
            let newCount: Int
            switch result {
            case let .inUse(info, count):
                newCount = count
                if verbose {
                    os_log("\(Self.t)🔺 增加引用 [引用: \(info.refCount), 总数: \(count)]: \(url.lastPathComponent)")
                }
            case let .removed(_, count):
                newCount = count
            case .notFound:
                newCount = await store.getActiveCount()
            }

            await MainActor.run {
                self.activeMonitorCount = newCount
            }

            return existing.publisher.eraseToAnyPublisher()
        }

        // 先查询初始进度，避免发送错误的初始值
        let initialProgress = url.downloadProgress

        // 使用正确的初始值创建监听器
        let publisher = CurrentValueSubject<Double, Never>(initialProgress)

        // 创建监听任务（轻量级轮询，使用 resourceValues 查询）
        let monitorTask = await createMonitorTask(for: url, publisher: publisher, verbose: verbose)

        let info = MonitorInfo(
            publisher: publisher,
            refCount: 1,
            monitorTask: monitorTask
        )

        await store.set(info, for: url)

        // 更新主线程上的计数
        let newCount = await store.getActiveCount()
        await MainActor.run {
            self.activeMonitorCount = newCount
        }

        if verbose {
            os_log("\(Self.t)➕ 创建监听器 [总数: \(newCount)]: \(url.lastPathComponent)")
        }

        return publisher.eraseToAnyPublisher()
    }

    /// 取消订阅指定 URL 的下载进度
    ///
    /// 减少引用计数，当引用计数归零时清理该 URL 的监听器。
    ///
    /// - Parameter url: 要取消订阅的文件 URL
    public func unsubscribe(url: URL, verbose: Bool) async {
        let result = await store.updateRefCount(for: url, increment: false)

        // 更新主线程上的计数
        let newCount: Int
        switch result {
        case .notFound:
            newCount = await store.getActiveCount()
            // 监听器不存在，静默忽略（可能是重复取消订阅）

        case let .inUse(info, count):
            newCount = count
            // 还有其他订阅者，只是减少了引用计数
            if verbose {
                os_log("\(Self.t)🔻 减少引用 [引用: \(info.refCount), 总数: \(count)]: \(url.lastPathComponent)")
            }

        case let .removed(removedInfo, count):
            newCount = count
            // 引用计数归零，监听器已从 store 中移除，取消任务
            removedInfo.monitorTask?.cancel()
            if verbose {
                os_log("\(Self.t)🗑️ 移除监听器 [剩余: \(count)]: \(url.lastPathComponent)")
            }
        }

        await MainActor.run {
            self.activeMonitorCount = newCount
        }
    }

    /// 创建监听任务
    /// 使用轻量级轮询而非持续的 NotificationCenter 监听
    /// - Parameters:
    ///   - url: 要监听的文件 URL
    ///   - publisher: 进度发布者
    private func createMonitorTask(
        for url: URL,
        publisher: CurrentValueSubject<Double, Never>,
        verbose: Bool
    ) async -> Task<Void, Never> {
        // 必须在 MainActor 上创建和管理 NSMetadataQuery
        return Task { @MainActor in
            // 如果已经完成了，直接发送 1.0 并退出
            if url.isDownloaded {
                publisher.send(1.0)
                return
            }

            if verbose {
                os_log("\(Self.t)🔍 开始创建 NSMetadataQuery 监听: \(url.lastPathComponent)")
            }

            let query = NSMetadataQuery()
            // 关键优化：将 Query 的操作队列设置为后台队列，移出主线程
            query.operationQueue = AvatarDownloadMonitor.processingQueue
            query.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope, NSMetadataQueryUbiquitousDataScope]
            // 使用文件名匹配
            query.predicate = NSPredicate(format: "%K == %@", NSMetadataItemFSNameKey, url.lastPathComponent)

            // 监听更新通知
            // 注意：设置了 operationQueue 后，Notification 会在 operationQueue 上回调
            let observer = NotificationCenter.default.addObserver(
                forName: .NSMetadataQueryDidUpdate,
                object: query,
                queue: nil // nil 表示使用 posted queue（即 operationQueue）
            ) { [weak query] _ in
                guard let query = query else { return }
                guard let item = query.results.first as? NSMetadataItem else { return }
                
                // 获取下载进度
                if let percent = item.value(forAttribute: NSMetadataUbiquitousItemPercentDownloadedKey) as? Double {
                    let progress = percent / 100.0
                    publisher.send(min(progress, 1.0))
                    
                    if verbose {
                        os_log("\(Self.t)⏬ 进度更新: \(Int(percent))% - \(url.lastPathComponent)")
                    }
                }
                
                // 检查是否下载完成
                let status = item.value(forAttribute: NSMetadataUbiquitousItemDownloadingStatusKey) as? String
                if status == NSMetadataUbiquitousItemDownloadingStatusCurrent {
                    publisher.send(1.0)
                    if verbose {
                        os_log("\(Self.t)✅ 下载完成(Query): \(url.lastPathComponent)")
                    }
                }
            }
            
            // 监听初始结果收集完成
            let finishGatheringObserver = NotificationCenter.default.addObserver(
                forName: .NSMetadataQueryDidFinishGathering,
                object: query,
                queue: nil // nil 表示使用 posted queue（即 operationQueue）
            ) { [weak query] _ in
                guard let query = query else { return }
                // 必须在 query 所在的 operationQueue 上调用 enableUpdates，这里已经在 queue 上了
                query.enableUpdates()
                
                if let item = query.results.first as? NSMetadataItem {
                    if let percent = item.value(forAttribute: NSMetadataUbiquitousItemPercentDownloadedKey) as? Double {
                         let progress = percent / 100.0
                         publisher.send(min(progress, 1.0))
                    }
                } else if verbose {
                    os_log("\(Self.t)⚠️ Query 未找到文件: \(url.lastPathComponent)")
                }
            }

            // 启动查询
            query.start()
            
            // 保持任务运行直到被取消
            do {
                try await withTaskCancellationHandler {
                    // 挂起任务直到被取消
                    try await Task.sleep(nanoseconds: 365 * 24 * 60 * 60 * 1_000_000_000)
                } onCancel: {
                    Task { @MainActor in
                        if verbose {
                            os_log("\(Self.t)🛑 停止监听: \(url.lastPathComponent)")
                        }
                        query.stop()
                        NotificationCenter.default.removeObserver(observer)
                        NotificationCenter.default.removeObserver(finishGatheringObserver)
                    }
                }
            } catch {
                // 任务取消时会抛出错误
            }
        }
    }
}
