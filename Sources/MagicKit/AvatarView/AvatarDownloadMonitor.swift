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
    public nonisolated(unsafe) static let emoji = "📥"
    /// 是否输出详细日志
    public nonisolated(unsafe) static let verbose = false

    /// 单例实例
    public static let shared = AvatarDownloadMonitor()

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

    private init() {
        if Self.verbose {
            os_log("\(Self.t)🚀 全局下载监控器初始化")
        }
    }

    /// 订阅指定 URL 的下载进度
    ///
    /// 如果该 URL 已有监听器，增加引用计数并返回现有发布者。
    /// 如果没有，创建新的监听器并开始监控。
    ///
    /// - Parameter url: 要监听的文件 URL
    /// - Returns: 进度发布者，发送 0-1 之间的值
    public func subscribe(url: URL) async -> AnyPublisher<Double, Never> {
        // 检查是否已存在监听器
        if let existing = await store.get(url) {
            // 已存在，增加引用计数
            let result = await store.updateRefCount(for: url, increment: true)

            // 更新主线程上的计数
            let newCount: Int
            switch result {
            case let .inUse(info, count):
                newCount = count
                if Self.verbose {
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
        let initialProgress = await queryProgress(for: url)

        // 使用正确的初始值创建监听器
        let publisher = CurrentValueSubject<Double, Never>(initialProgress)

        // 创建监听任务（轻量级轮询，使用 resourceValues 查询）
        let monitorTask = await createMonitorTask(for: url, publisher: publisher, skipInitialQuery: true)

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

        if Self.verbose {
            os_log("\(Self.t)➕ 创建监听器 [总数: \(newCount)]: \(url.lastPathComponent)")
        }

        return publisher.eraseToAnyPublisher()
    }

    /// 取消订阅指定 URL 的下载进度
    ///
    /// 减少引用计数，当引用计数归零时清理该 URL 的监听器。
    ///
    /// - Parameter url: 要取消订阅的文件 URL
    public func unsubscribe(url: URL) async {
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
            if Self.verbose {
                os_log("\(Self.t)🔻 减少引用 [引用: \(info.refCount), 总数: \(count)]: \(url.lastPathComponent)")
            }

        case let .removed(removedInfo, count):
            newCount = count
            // 引用计数归零，监听器已从 store 中移除，取消任务
            removedInfo.monitorTask?.cancel()
            if Self.verbose {
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
    ///   - skipInitialQuery: 是否跳过初始进度查询（已在调用方查询过）
    private func createMonitorTask(
        for url: URL,
        publisher: CurrentValueSubject<Double, Never>,
        skipInitialQuery: Bool = false
    ) async -> Task<Void, Never> {
        return Task.detached(priority: .utility) { [weak self] in
            // 使用单次 I/O 检查文件状态
            let initialProgress: Double
            if skipInitialQuery {
                // 跳过查询，使用 publisher 的当前值（已在调用方设置）
                initialProgress = await MainActor.run { publisher.value }
            } else {
                initialProgress = await self?.queryProgress(for: url) ?? 1.0
            }

            // 如果已经完成（本地文件或已下载的 iCloud 文件），直接返回
            if initialProgress >= 1.0 {
                await MainActor.run {
                    publisher.send(1.0)
                }
                return
            }

            // 如果不在下载中，直接返回
            if url.checkIsDownloading() == false {
                return
            }

            // 发送初始进度（如果跳过了初始查询，publisher 已经有了正确的初始值，不需要再发送）
            if !skipInitialQuery {
                await MainActor.run {
                    publisher.send(initialProgress)
                }
            }

            // 进度日志节流控制
            var lastLoggedProgress: Double = 0
            var lastLogTime = Date()

            // 轮询检查下载进度（每 1 秒检查一次，降低 I/O 频率）
            let pollInterval: UInt64 = 1000000000 // 1 秒

            while !Task.isCancelled {
                // 等待下一次轮询
                do {
                    try await Task.sleep(nanoseconds: pollInterval)
                } catch {
                    // 任务被取消
                    break
                }

                let progress = await self?.queryProgress(for: url) ?? 1.0

                await MainActor.run {
                    publisher.send(progress)
                }

                // 决定是否输出进度日志
                var shouldLog = false
                if progress >= 1.0 {
                    shouldLog = true
                } else {
                    let now = Date()
                    let timeSinceLastLog = now.timeIntervalSince(lastLogTime)
                    let progressChange = progress - lastLoggedProgress

                    // 每3秒或每5%输出一次
                    if timeSinceLastLog >= 3.0 || progressChange >= 0.05 {
                        shouldLog = true
                        lastLogTime = now
                        lastLoggedProgress = progress
                    }
                }

                if shouldLog, AvatarDownloadMonitor.verbose {
                    let percentage = Int(progress * 100)
                    if progress >= 1.0 {
                        await MainActor.run {
                            os_log("\(AvatarDownloadMonitor.t)✅ 下载完成: \(url.lastPathComponent)")
                        }
                    } else {
                        await MainActor.run {
                            os_log("\(AvatarDownloadMonitor.t)⏬ 下载中: \(url.lastPathComponent) - \(percentage)%")
                        }
                    }
                }

                // 下载完成，退出循环
                if progress >= 1.0 {
                    break
                }
            }
        }
    }

    /// 查询文件下载进度
    /// 使用单次 resourceValues 调用获取所有需要的属性，减少 I/O
    private nonisolated func queryProgress(for url: URL) async -> Double {
        // 使用单次 resourceValues 调用，获取所有需要的属性
        // 避免了之前的多次 I/O 调用（checkIsICloud + checkIsDownloaded）
        guard let resources = try? url.resourceValues(forKeys: [
            .isUbiquitousItemKey,
            .ubiquitousItemDownloadingStatusKey,
            .fileSizeKey,
            .fileAllocatedSizeKey,
        ]) else {
            // 无法获取资源信息，可能是本地文件
            return 1.0
        }

        // 如果不是 iCloud 文件，直接返回已完成
        guard resources.isUbiquitousItem == true else {
            return 1.0
        }

        // 检查下载状态
        if let status = resources.ubiquitousItemDownloadingStatus {
            if status == .current {
                return 1.0
            }
        }

        // 使用文件大小计算下载进度
        if let totalSize = resources.fileSize,
           let downloadedSize = resources.fileAllocatedSize,
           totalSize > 0 {
            return min(1.0, Double(downloadedSize) / Double(totalSize))
        }

        return 0.0
    }
}
