import AVFoundation
import Foundation
import MagicCore
import SwiftUI

public extension MagicPlayMan {
    /// 加载并播放一个 URL
    /// - Parameters:
    ///   - url: 要播放的媒体 URL
    ///   - title: 可选的标题，如果不提供则使用文件名
    ///   - autoPlay: 是否自动开始播放，默认为 true
    @MainActor
    func play(_ url: URL, autoPlay: Bool = true) async {
        log("Play: \(url.title), AutoPlay: \(autoPlay)")
        self.setCurrentURL(url)

        // 检查 URL 是否有效
        guard url.isFileURL || url.isNetworkURL else {
            log("Invalid URL scheme: \(url.scheme ?? "nil")", level: .error)
            await stop()
            setState(.failed(.playbackError("Invalid URL scheme")))
            return
        }

        // 判断媒体类型
        if url.isVideo == false && url.isAudio == false {
            log("Unsupported media type: \(url.pathExtension)", level: .error)
            await stop()
            setState(.failed(.unsupportedFormat(url.pathExtension)))
            return
        }

        // 加载资源
        log("Load: \(url.title), AutoPlay: \(autoPlay)")
        await loadFromURL(url, autoPlay: autoPlay)

        if isPlaylistEnabled {
            append(url)
            log("Added URL to playlist: \(url.absoluteString)")
        }
    }

    /// 添加资源到播放列表
    func append(_ asset: URL) {
        guard isPlaylistEnabled else {
            log("Cannot append: playlist is disabled", level: .warning)
            return
        }
        playlist.append(asset)
    }

    /// 清空播放列表
    func clearPlaylist() {
        guard isPlaylistEnabled else {
            log("Cannot clear: playlist is disabled", level: .warning)
            return
        }
        playlist.clear()
    }

    /// 播放下一首
    func next() {
        log("下一首，当前是否有Asset -> \(self.hasAsset)")
        guard hasAsset else { return }

        if isPlaylistEnabled {
            log("下一首，播放列表已启用")
            if let nextAsset = _playlist.playNext(mode: playMode) {
                log("下一首，播放列表已启用且下一个是：\(nextAsset.title)")
                Task {
                    await loadFromURL(nextAsset)
                }
            } else {
                log("下一首，播放列表已启用但没有 NextAsset")
            }
        } else if events.hasNavigationSubscribers {
            log("下一首，播放列表已禁用且有 NavigationSubscribers")

            // 如果播放列表被禁用但有订阅者，发送请求下一首事件
            if let currentAsset = currentAsset {
                log("请求下一首")
                events.onNextRequested.send(currentAsset)
            }
        } else {
            log("下一首，播放列表已禁用且无 NavigationSubscribers")
        }
    }

    /// 播放上一首
    func previous() {
        guard hasAsset else { return }

        if isPlaylistEnabled {
            if let previousAsset = _playlist.playPrevious(mode: playMode) {
                Task {
                    await loadFromURL(previousAsset)
                }
            }
        } else if events.hasNavigationSubscribers {
            // 如果播放列表被禁用但有订阅者，发送请求上一首事件
            if let currentAsset = currentURL {
                events.onPreviousRequested.send(currentAsset)
            }
        }
    }

    /// 从播放列表中移除指定索引的资源
    func removeFromPlaylist(at index: Int) {
        guard isPlaylistEnabled else {
            log("Cannot remove: playlist is disabled", level: .warning)
            return
        }
        playlist.remove(at: index)
    }

    /// 移动播放列表中的资源
    func moveInPlaylist(from: Int, to: Int) {
        guard isPlaylistEnabled else {
            log("Cannot move: playlist is disabled", level: .warning)
            return
        }
        playlist.move(from: from, to: to)
    }

    /// 开始播放
    func play() {
        guard hasAsset else {
            log("Cannot play: no asset loaded", level: .warning)
            return
        }

        if currentTime == duration {
            self.seek(time: 0)
        }

        _player.play()
        log("Started playback: \(currentURL?.title ?? "Unknown")")
        updateNowPlayingInfo()

        Task {
            await self.setState(.playing)
        }
    }

    /// 暂停播放
    func pause() {
        guard hasAsset else { return }

        _player.pause()
        log("Paused playback")
        updateNowPlayingInfo()

        Task {
            await self.setState(.paused)
        }
    }

    /// 停止播放
    @MainActor
    func stop() async {
        _player.pause()
        await _player.seek(to: .zero)

        log("⏹️ Stopped playback")
        updateNowPlayingInfo()

        await self.setState(.stopped)
    }

    /// 切换播放状态
    /// 如果当前正在播放则暂停，如果当前已暂停则开始播放
    func toggle() {
        switch state {
        case .playing:
            pause()
        case .paused, .stopped:
            play()
        case .loading, .failed, .idle:
            // 在这些状态下不执行任何操作
            log("Cannot toggle playback in current state: \(state)", level: .warning)
            break
        }
    }

    /// 跳转到指定时间
    /// - Parameter time: 目标时间（秒）
    func seek(time: TimeInterval) {
        guard hasAsset else {
            log("⚠️ Cannot seek: no asset loaded", level: .warning)
            return
        }

        let targetTime = CMTime(seconds: time, preferredTimescale: 600)
        log("⏩ Seeking to \(Int(time))s")
        _player.seek(to: targetTime) { [weak self] finished in
            guard let self = self, finished else { return }
            Task { @MainActor in
                self.setCurrentTime(time)
                self.updateNowPlayingInfo()
            }
        }
    }

    /// 快进指定时间
    /// - Parameter seconds: 快进的秒数，默认 10 秒
    func skipForward(_ seconds: TimeInterval = 10) {
        seek(time: currentTime + seconds)
        log("⏩ Skipped forward \(Int(seconds))s")
    }

    /// 快退指定时间
    /// - Parameter seconds: 快退的秒数，默认 10 秒
    func skipBackward(_ seconds: TimeInterval = 10) {
        seek(time: max(currentTime - seconds, 0))
        log("⏪ Skipped backward \(Int(seconds))s")
    }

    /// 调整音量
    /// - Parameter volume: 目标音量，范围 0-1
    func setVolume(_ volume: Float) {
        _player.volume = max(0, min(1, volume))
        log("🔊 Volume set to \(Int(volume * 100))%")
    }

    /// 静音控制
    /// - Parameter muted: 是否静音
    func setMuted(_ muted: Bool) {
        _player.isMuted = muted
        log(muted ? "🔇 Audio muted" : "🔊 Audio unmuted")
    }

    internal func updateState(_ newState: PlaybackState) {
        Task { @MainActor in
            self.setState(newState)
        }
    }

    /// 启用播放列表功能
    func enablePlaylist() async {
        guard !isPlaylistEnabled else { return }

        await setPlaylistEnabled(true)
        log("Playlist enabled")
    }

    /// 禁用播放列表功能
    /// 禁用时会保留当前播放的资源（如果有），清除其他资源
    func disablePlaylist() async {
        guard isPlaylistEnabled else { return }

        await setPlaylistEnabled(false)
        log("Playlist disabled")

        // 如果禁用播放列表，保留当前播放的资源
        if let currentAsset = currentURL {
            await setItems([currentAsset])
            await setCurrentIndex(0)
        } else {
            await setItems([])
            await setCurrentIndex(-1)
        }
    }

    /// 切换当前资源的喜欢状态
    func toggleLike() {
        guard let asset = currentURL else { return }
        setLike(!likedAssets.contains(asset))
    }

    func log(_ message: String, level: MagicLogEntry.Level = .info) {
        if self.verbose {
            logger.log(message, level: level)
        }
    }

    /// 清理所有缓存
    func clearCache() {
        do {
            try cache?.clear()
            log("🗑️ Cache cleared")
        } catch {
            log("❌ Failed to clear cache: \(error.localizedDescription)", level: .error)
        }
    }

    /// 设置当前资源的喜欢状态
    /// - Parameter isLiked: 是否喜欢
    func setLike(_ isLiked: Bool) {
        guard let asset = currentURL else {
            log("⚠️ Cannot set like: no asset loaded", level: .warning)
            return
        }

        var newLikedAssets = likedAssets
        if isLiked {
            newLikedAssets.insert(asset)
            log("❤️ Added to liked: \(asset.title)")
        } else {
            newLikedAssets.remove(asset)
            log("💔 Removed from liked: \(asset.title)")
        }

        Task {
            await setLikedAssets(newLikedAssets)
        }
        // 通知订阅者喜欢状态变化
        events.onLikeStatusChanged.send((asset: asset, isLiked: isLiked))
        updateNowPlayingInfo()
    }

    /// 设置详细日志模式
    /// - Parameter enabled: 是否启用详细日志
    func setVerboseMode(_ enabled: Bool) {
        self.verbose = enabled
        log("🔍 Verbose mode \(enabled ? "enabled" : "disabled")")
    }

    /// 设置播放模式
    /// - Parameter mode: 要设置的播放模式
    func changePlayMode(_ mode: MagicPlayMode) {
        Task {
            await setPlayMode(mode)
        }
        log("Playback mode set to: \(mode.displayName)")
    }
}

#Preview("MagicPlayMan") {
    MagicPlayMan
        .PreviewView()
}
