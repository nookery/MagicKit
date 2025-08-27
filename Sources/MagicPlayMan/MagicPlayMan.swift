import AVFoundation
import Combine
import Foundation
import MagicCore
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
        currentTime = time
    }

    @MainActor
    func setDuration(_ value: TimeInterval) {
        duration = value
    }

    @MainActor
    func setProgress(_ value: Double) {
        progress = value
    }

    @MainActor
    func setPlaylistEnabled(_ value: Bool) {
        isPlaylistEnabled = value
    }

    @MainActor
    func setLikedAssets(_ assets: Set<URL>) {
        likedAssets = assets
    }

    @MainActor
    func setState(_ state: PlaybackState) {
        self.state = state

        log("播放状态变更：\(state.stateText)")
        events.onStateChanged.send(state)
    }

    @MainActor
    func setCurrentURL(_ url: URL?) {
        currentURL = url

        if let url = currentURL {
            events.onCurrentURLChanged.send(url)
        }
    }

    @MainActor
    func setPlayMode(_ mode: MagicPlayMode) {
        playMode = mode

        log("播放模式变更：\(playMode)")
        events.onPlayModeChanged.send(playMode)
    }

    @MainActor
    func setCurrentDownloadObservers(_ observers: (progressObserver: AnyCancellable, finishObserver: AnyCancellable)?) {
        currentDownloadObservers = observers
    }
}

#Preview("MagicPlayMan") {
    MagicPlayMan
        .PreviewView()
        .inMagicContainer(containerHeight: 1000)
}
