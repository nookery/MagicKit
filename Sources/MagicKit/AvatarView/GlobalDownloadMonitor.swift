import Combine
import Foundation
import OSLog
import SwiftUI

/// 全局下载进度监控器
///
/// 集中管理所有文件的下载进度监听，避免每个视图创建独立的监听器。
/// 使用单例模式和引用计数，确保每个 URL 只有一个监听器，当没有视图订阅时自动清理。
@MainActor
public final class GlobalDownloadMonitor: SuperLog {
    nonisolated(unsafe) public static let emoji = "📥"
    nonisolated(unsafe) public static let verbose = false

    /// 单例实例
    public static let shared = GlobalDownloadMonitor()

    /// 监听器信息
    private struct MonitorInfo {
        let publisher: CurrentValueSubject<Double, Never>
        var refCount: Int
        var cancellables: Set<AnyCancellable>
    }

    /// 监听器字典 [URL: MonitorInfo]
    private var monitors: [URL: MonitorInfo] = [:]

    /// 活跃的监听器数量（用于调试）
    private(set) public var activeMonitorCount: Int = 0

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
    public func subscribe(url: URL) -> AnyPublisher<Double, Never> {
        // 如果已存在，增加引用计数
        if var existing = monitors[url] {
            existing.refCount += 1
            monitors[url] = existing

            if Self.verbose {
                os_log("\(Self.t)♻️ 复用监听器 [引用: \(existing.refCount)]: \(url.lastPathComponent)")
            }
            return existing.publisher.eraseToAnyPublisher()
        }

        // 创建新的监听器
        if Self.verbose {
            os_log("\(Self.t)👂 创建新监听器: \(url.lastPathComponent)")
        }

        // 使用默认初始值（避免在主线程调用 isDownloaded）
        let publisher = CurrentValueSubject<Double, Never>(0.0)
        var cancellables: Set<AnyCancellable> = []

        // 在后台查询初始进度和下载状态
        Task.detached(priority: .utility) { [weak self] in
            guard let self = self else { return }
            let initialProgress = await self.queryMetadataProgress(for: url)

            await MainActor.run { [weak self] in
                guard self != nil else { return }
                // 更新初始进度值（如果已下载完成则设为 1.0）
                if initialProgress > publisher.value {
                    publisher.send(initialProgress)
                }
            }
        }

        // 监听下载进度
        let progressCancellable = url.onDownloading(
            verbose: Self.verbose && false,
            caller: "GlobalDownloadMonitor",
            updateInterval: 0.5
        ) { [weak self] progress in
            Task { @MainActor in
                publisher.send(progress)

                if progress >= 1.0 {
                    // 下载完成，延迟清理
                    try? await Task.sleep(nanoseconds: 100_000_000)
                    // 注意：这里不主动清理，等待所有订阅者取消
                }
            }
        }
        progressCancellable.store(in: &cancellables)

        // 监听下载完成
        let finishedCancellable = url.onDownloadFinished(
            verbose: Self.verbose && false,
            caller: "GlobalDownloadMonitor"
        ) {
            publisher.send(1.0)
        }
        finishedCancellable.store(in: &cancellables)

        monitors[url] = MonitorInfo(
            publisher: publisher,
            refCount: 1,
            cancellables: cancellables
        )

        activeMonitorCount = monitors.count

        if Self.verbose {
            os_log("\(Self.t)📊 活跃监听器: \(self.activeMonitorCount)")
        }

        return publisher.eraseToAnyPublisher()
    }

    /// 取消订阅指定 URL 的下载进度
    ///
    /// 减少引用计数，当引用计数归零时清理该 URL 的监听器。
    ///
    /// - Parameter url: 要取消订阅的文件 URL
    public func unsubscribe(url: URL) {
        guard var existing = monitors[url] else {
            return
        }

        existing.refCount -= 1

        if existing.refCount <= 0 {
            existing.cancellables.removeAll()
            monitors.removeValue(forKey: url)
        } else {
            // 还有其他订阅者，更新引用计数
            monitors[url] = existing
        }

        activeMonitorCount = monitors.count

        if Self.verbose {
            os_log("\(Self.t)📊 活跃监听器: \(self.activeMonitorCount)")
        }
    }

    /// 在后台查询元数据进度
    private nonisolated func queryMetadataProgress(for url: URL) async -> Double {
        // 快速检查：如果是本地文件或已下载，直接返回
        if url.isLocal {
            return 1.0
        }

        if !url.checkIsICloud(verbose: false) {
            return 0.0
        }

        // 在后台查询 isDownloaded（避免阻塞主线程）
        let isDownloaded = url.isDownloaded
        if isDownloaded {
            return 1.0
        }

        // 尝试从 NSMetadataItem 获取进度
        let query = NSMetadataQuery()
        query.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
        query.predicate = NSPredicate(format: "%K == %@", NSMetadataItemURLKey, url as NSURL)

        query.start()
        defer { query.stop() }

        // 等待查询完成
        await Task.yield()

        if let item = query.results.first as? NSMetadataItem {
            if let status = item.value(forAttribute: NSMetadataUbiquitousItemDownloadingStatusKey) as? String {
                if status == NSMetadataUbiquitousItemDownloadingStatusCurrent {
                    return 1.0
                }
            }
            if let percent = item.value(forAttribute: NSMetadataUbiquitousItemPercentDownloadedKey) as? Double {
                return percent / 100.0
            }
        }

        return 0.0
    }

    /// 强制清理所有监听器（主要用于调试或测试）
    public func cleanup() {
        if Self.verbose {
            os_log("\(Self.t)🧹 强制清理所有监听器")
        }

        for (_, var monitor) in monitors {
            monitor.cancellables.removeAll()
        }

        monitors.removeAll()
        activeMonitorCount = 0
    }
}
