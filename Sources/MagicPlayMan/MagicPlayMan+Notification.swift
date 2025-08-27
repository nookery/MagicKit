import Foundation
import Combine

/// PlayMan 通知系统
/// 通过通知中心解耦 PlayMan 和视图之间的依赖关系
/// 视图可以选择性监听自己感兴趣的事件，实现精确的重绘控制
@MainActor
extension MagicPlayMan {
    // MARK: - 通知名称定义

    /// 通知名称常量
    public enum NotificationName {
        public static let timeUpdate = Notification.Name("PlayManTimeUpdate")
        public static let assetChanged = Notification.Name("PlayManAssetChanged")
        public static let stateChanged = Notification.Name("PlayManStateChanged")
        public static let durationChanged = Notification.Name("PlayManDurationChanged")
        public static let bufferingStateChanged = Notification.Name("PlayManBufferingStateChanged")
        public static let downloadProgressChanged = Notification.Name("PlayManDownloadProgressChanged")
    }

    // MARK: - 通知发送方法

    /// 发送时间更新通知
    /// - Parameters:
    ///   - currentTime: 当前播放时间
    ///   - progress: 播放进度 (0-1)
    func sendTimeUpdate(currentTime: TimeInterval, progress: Double) {
        let userInfo: [String: Any] = [
            "currentTime": currentTime,
            "progress": progress
        ]

        NotificationCenter.default.post(
            name: NotificationName.timeUpdate,
            object: self,
            userInfo: userInfo
        )
    }

    /// 发送播放资源变更通知
    /// - Parameter asset: 当前播放资源URL
    func sendAssetChanged(asset: URL?) {
        let userInfo: [String: Any] = [
            "asset": asset as Any
        ]

        NotificationCenter.default.post(
            name: NotificationName.assetChanged,
            object: self,
            userInfo: userInfo
        )
    }

    /// 发送播放状态变更通知
    /// - Parameter isPlaying: 是否正在播放
    func sendStateChanged(isPlaying: Bool) {
        let userInfo: [String: Any] = [
            "isPlaying": isPlaying
        ]

        NotificationCenter.default.post(
            name: NotificationName.stateChanged,
            object: self,
            userInfo: userInfo
        )
    }

    /// 发送时长变更通知
    /// - Parameter duration: 媒体总时长
    func sendDurationChanged(duration: TimeInterval) {
        let userInfo: [String: Any] = [
            "duration": duration
        ]

        NotificationCenter.default.post(
            name: NotificationName.durationChanged,
            object: self,
            userInfo: userInfo
        )
    }

    /// 发送缓冲状态变更通知
    /// - Parameter isBuffering: 是否正在缓冲
    func sendBufferingStateChanged(isBuffering: Bool) {
        let userInfo: [String: Any] = [
            "isBuffering": isBuffering
        ]

        NotificationCenter.default.post(
            name: NotificationName.bufferingStateChanged,
            object: self,
            userInfo: userInfo
        )
    }

    /// 发送下载进度变更通知
    /// - Parameter progress: 下载进度 (0-1)
    func sendDownloadProgressChanged(progress: Double) {
        let userInfo: [String: Any] = [
            "downloadProgress": progress
        ]

        NotificationCenter.default.post(
            name: NotificationName.downloadProgressChanged,
            object: self,
            userInfo: userInfo
        )
    }
}

// MARK: - 通知监听辅助扩展

extension NotificationCenter {
    /// 监听 PlayMan 时间更新通知
    /// - Parameters:
    ///   - object: PlayMan 实例
    ///   - handler: 处理闭包，参数为 (currentTime: TimeInterval, progress: Double)
    /// - Returns: 观察者令牌
    func observePlayManTimeUpdate(
        for object: MagicPlayMan? = nil,
        handler: @escaping (TimeInterval, Double) -> Void
    ) -> AnyCancellable {
        publisher(for: MagicPlayMan.NotificationName.timeUpdate, object: object)
            .compactMap { notification -> (TimeInterval, Double)? in
                guard let currentTime = notification.userInfo?["currentTime"] as? TimeInterval,
                      let progress = notification.userInfo?["progress"] as? Double else {
                    return nil
                }
                return (currentTime, progress)
            }
            .sink(receiveValue: handler)
    }

    /// 监听 PlayMan 播放资源变更通知
    /// - Parameters:
    ///   - object: PlayMan 实例
    ///   - handler: 处理闭包，参数为 asset: URL?
    /// - Returns: 观察者令牌
    func observePlayManAssetChanged(
        for object: MagicPlayMan? = nil,
        handler: @escaping (URL?) -> Void
    ) -> AnyCancellable {
        publisher(for: MagicPlayMan.NotificationName.assetChanged, object: object)
            .map { notification -> URL? in
                notification.userInfo?["asset"] as? URL
            }
            .sink(receiveValue: handler)
    }

    /// 监听 PlayMan 播放状态变更通知
    /// - Parameters:
    ///   - object: PlayMan 实例
    ///   - handler: 处理闭包，参数为 isPlaying: Bool
    /// - Returns: 观察者令牌
    func observePlayManStateChanged(
        for object: MagicPlayMan? = nil,
        handler: @escaping (Bool) -> Void
    ) -> AnyCancellable {
        publisher(for: MagicPlayMan.NotificationName.stateChanged, object: object)
            .map { notification -> Bool in
                notification.userInfo?["isPlaying"] as? Bool ?? false
            }
            .sink(receiveValue: handler)
    }

    /// 监听 PlayMan 时长变更通知
    /// - Parameters:
    ///   - object: PlayMan 实例
    ///   - handler: 处理闭包，参数为 duration: TimeInterval
    /// - Returns: 观察者令牌
    func observePlayManDurationChanged(
        for object: MagicPlayMan? = nil,
        handler: @escaping (TimeInterval) -> Void
    ) -> AnyCancellable {
        publisher(for: MagicPlayMan.NotificationName.durationChanged, object: object)
            .map { notification -> TimeInterval in
                notification.userInfo?["duration"] as? TimeInterval ?? 0
            }
            .sink(receiveValue: handler)
    }
}
