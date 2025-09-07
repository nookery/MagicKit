import AVFoundation
import Combine
import Foundation
import MagicCore
import os.log
import SwiftUI

extension MagicPlayMan {
    /// 从 URL 加载媒体
    /// - Parameters:
    ///   - url: 媒体文件的 URL
    ///   - autoPlay: 是否自动开始播放，默认为 true
    func loadFromURL(_ url: URL, autoPlay: Bool = true) async {
        await stop()
        await self.setCurrentURL(url)
        await self.setState(.loading(.preparing))

        // 检查文件是否存在
        guard url.isFileExist else {
            await self.setState(.failed(.invalidAsset))
            return
        }

        await downloadAndCache(url)

        let item = AVPlayerItem(url: url)
        
        // 使用 Combine 监听状态，避免 @Sendable 捕获问题
        let statusObserver = item.publisher(for: \.status)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                switch status {
                case .readyToPlay:
                    Task { @MainActor in
                        // 播放器准备就绪后，清理下载监听器
                        self.cleanupDownloadObservers()
                        
                        self.setDuration(item.duration.seconds)
                        if self.isLoading {
                            self.setState(autoPlay ? .playing : .paused)
                            if autoPlay { self.play() }
                        }
                    }
                case .failed:
                    let message = item.error?.localizedDescription ?? "Unknown error"
                    Task { @MainActor in
                        // 播放失败时也要清理下载监听器
                        self.cleanupDownloadObservers()
                        
                        self.setState(.failed(.playbackError(message)))
                    }
                default:
                    break
                }
            }

        cancellables.insert(statusObserver)
        _player.replaceCurrentItem(with: item)
    }

    /// 下载并缓存资源
    @MainActor
    private func downloadAndCache(_ url: URL) {
        guard cache != nil else {
            return
        }
        
        if url.isDownloaded {
            return
        }

        Task {
            await self.setState(.loading(.connecting))
        }

        // 添加节流控制
        let progressSubject = CurrentValueSubject<Double, Never>(0)
        let progressObserver = url.onDownloading(caller: "MagicPlayMan") { progress in
            // 这里接收进度更新，应该在后台线程处理
            DispatchQueue.global().async {
                progressSubject.send(progress)
            }
        }

        // 使用 Combine 的 throttle 操作符限制更新频率
        let progressUpdateObserver = progressSubject
            .throttle(for: .milliseconds(3000), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] progress in
                guard let self = self else { return }
                Task {
                    // 只有在加载状态时才更新下载进度，避免与播放状态冲突
                    if case .loading = self.state {
                        await self.setState(.loading(.downloading(progress)))
                    }
                }
            }

        cancellables.insert(progressUpdateObserver)

        // 监听下载完成
        let finishObserver = url.onDownloadFinished(verbose: self.verbose, caller: "MagicPlayMan") { [weak self] in
            guard let self = self else { return }
            self.cleanupDownloadObservers()
        }

        // 存储下载监听器引用
        self.setCurrentDownloadObservers((progressObserver, finishObserver))

        // 开始下载
        Task {
            do {
                try await url.download(verbose: true, reason: "MagicPlayMan requested")
            } catch {
                await MainActor.run {
                    // 下载失败时清理监听器
                    self.cleanupDownloadObservers()
                    
                    self.setState(.failed(.networkError(error.localizedDescription)))
                    self.log("Download failed: \(error.localizedDescription)", level: .error)
                }
            }
        }
    }

    /// 清理下载监听器
    @MainActor
    private func cleanupDownloadObservers() {
        if let (progressObserver, finishObserver) = currentDownloadObservers {
            progressObserver.cancel()
            finishObserver.cancel()
            setCurrentDownloadObservers(nil)
        }
    }
}

// MARK: - Preview

#Preview("MagicPlayMan") {
    MagicPlayMan
        .PreviewView()
}
