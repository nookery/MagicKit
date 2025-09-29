import AVFoundation
import Combine
import Foundation
import MagicCore
import MagicUI
import MediaPlayer
import OSLog
import SwiftUI

public class MagicPlayMan: ObservableObject, SuperLog {
    public nonisolated static let emoji = "🎧"

    internal let _player = AVPlayer()
    internal var timeObserver: Any?
    internal var nowPlayingInfo: [String: Any] = [:]
    internal let _playlist = Playlist()
    internal var cache: AssetCache?
    internal var verbose: Bool = true
    internal let logger = MagicLogger()
    public var cancellables = Set<AnyCancellable>()
    public private(set) var downloadTask: URLSessionDataTask?

    /// 播放相关的事件发布者
    public private(set) lazy var events = PlaybackEvents()

    /// 当前下载监听器引用
    private(set) var currentDownloadObservers: (progressObserver: AnyCancellable, finishObserver: AnyCancellable)?
    
    /// 按钮缓存，避免重复创建
    private var _cachedPlayPauseButton: MagicButton?
    private var _cachedPlayModeButton: MagicButton?
    private var _cachedLikeButton: MagicButton?
    private var _cachedPlaylistToggleButton: MagicButton?

    @Published public private(set) var items: [URL] = []
    @Published public private(set) var currentIndex: Int = -1
    @Published public private(set) var playMode: MagicPlayMode = .sequence
    @Published public private(set) var currentURL: URL?
    @Published public private(set) var state: PlaybackState = .idle
    @Published public private(set) var currentTime: TimeInterval = 0
    @Published public private(set) var duration: TimeInterval = 0
    @Published public private(set) var progress: Double = 0
    @Published public private(set) var isPlaylistEnabled: Bool = true
    @Published public private(set) var likedAssets: Set<URL> = []
}

//
//  说明：所有 set 方法必须定义在本文件中
//  原因：核心属性如 `currentURL` 使用了 `private(set)` 以限制外部直接赋值。
//       只有与其同文件的代码可以访问 setter，从而保证所有状态修改
//       都集中经由这些 set 方法（触发事件、日志与一致性校验）。
//  约定：
//  - 若需新增/修改状态，请新增对应的 set 方法并放在此分组中；
//  - 业务代码一律调用 set 方法，禁止直接对属性赋值。
//
// MARK: - Setter Methods

extension MagicPlayMan {
    @MainActor 
    func setItems(_ items: [URL]) {
        self.items = items
    }

    @MainActor
    func setCurrentIndex(_ index: Int) {
        currentIndex = index
    }

    @MainActor
    func setCurrentTime(_ time: TimeInterval) {
        let verbose = false
        let oldTime = currentTime
        currentTime = time

        // 发送时间更新通知
        if oldTime != time {
            if verbose {
                os_log("setCurrentTime: \(time)")
            }
            let progress = self.duration > 0 ? time / self.duration : 0
            sendTimeUpdate(currentTime: time, progress: progress)
        }
    }

    @MainActor
    func setDuration(_ value: TimeInterval) {
        let oldDuration = duration
        duration = value

        // 发送时长变更通知
        if oldDuration != value {
            sendDurationChanged(duration: value)
        }
    }

    @MainActor
    func setProgress(_ value: Double) {
        progress = value
    }

    @MainActor
    func setPlaylistEnabled(_ value: Bool) {
        isPlaylistEnabled = value
        
        // 清理播放列表切换按钮缓存
        setCachedPlaylistToggleButton(nil)
    }

    @MainActor
    func setLikedAssets(_ assets: Set<URL>) {
        likedAssets = assets
        
        // 清理喜欢按钮缓存，因为喜欢状态变化可能影响按钮外观
        setCachedLikeButton(nil)
    }

    @MainActor
    func setState(_ state: PlaybackState) {
        let oldState = self.state
        self.state = state

        log("播放状态变更：\(state.stateText)")
        events.onStateChanged.send(state)

        // 发送状态变更通知
        let isPlaying = (state == .playing)
        let oldIsPlaying = (oldState == .playing)
        if oldIsPlaying != isPlaying {
            sendStateChanged(isPlaying: isPlaying)
        }
        
        // 清理按钮缓存，因为状态变化可能影响按钮外观
        clearButtonCache()
    }

    @MainActor
    func setCurrentURL(_ url: URL?) {
        let oldURL = currentURL
        currentURL = url

        if let url = currentURL {
            events.onCurrentURLChanged.send(url)
        }

        // 发送播放资源变更通知
        if oldURL != url {
            sendAssetChanged(asset: url)
        }
        
        // 清理按钮缓存，因为当前资源变化可能影响按钮外观
        clearButtonCache()
    }

    @MainActor
    func setPlayMode(_ mode: MagicPlayMode) {
        playMode = mode

        log("播放模式变更：\(playMode)")
        events.onPlayModeChanged.send(playMode)
        
        // 清理播放模式按钮缓存
        setCachedPlayModeButton(nil)
    }

    @MainActor
    func setCurrentDownloadObservers(_ observers: (progressObserver: AnyCancellable, finishObserver: AnyCancellable)?) {
        currentDownloadObservers = observers
    }
    
    // MARK: - Button Cache Management
    
    /// 设置播放/暂停按钮缓存
    @MainActor
    func setCachedPlayPauseButton(_ button: MagicButton?) {
        _cachedPlayPauseButton = button
    }
    
    /// 设置播放模式按钮缓存
    @MainActor
    func setCachedPlayModeButton(_ button: MagicButton?) {
        _cachedPlayModeButton = button
    }
    
    /// 设置喜欢按钮缓存
    @MainActor
    func setCachedLikeButton(_ button: MagicButton?) {
        _cachedLikeButton = button
    }
    
    /// 设置播放列表切换按钮缓存
    @MainActor
    func setCachedPlaylistToggleButton(_ button: MagicButton?) {
        _cachedPlaylistToggleButton = button
    }
    
    /// 清理所有按钮缓存
    @MainActor
    func clearButtonCache() {
        setCachedPlayPauseButton(nil)
        setCachedPlayModeButton(nil)
        setCachedLikeButton(nil)
        setCachedPlaylistToggleButton(nil)
    }
    
    /// 获取播放/暂停按钮缓存
    var cachedPlayPauseButton: MagicButton? {
        _cachedPlayPauseButton
    }
    
    /// 获取播放模式按钮缓存
    var cachedPlayModeButton: MagicButton? {
        _cachedPlayModeButton
    }
    
    /// 获取喜欢按钮缓存
    var cachedLikeButton: MagicButton? {
        _cachedLikeButton
    }
    
    /// 获取播放列表切换按钮缓存
    var cachedPlaylistToggleButton: MagicButton? {
        _cachedPlaylistToggleButton
    }
}

#Preview("MagicPlayMan") {
    MagicPlayMan
        .PreviewView()
}
