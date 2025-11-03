import Foundation
import SwiftUI

/// MagicPlayMan 简单 View 扩展
/// 直接使用 SwiftUI 的 onReceive 封装通知监听
/// 让开发者可以用更简单的方式监听 PlayMan 的通知
@available(iOS 14.0, macOS 11.0, *)
public extension View {
    /// 监听播放时间更新通知
    /// - Parameter handler: 处理闭包，参数为 (currentTime: TimeInterval, progress: Double)
    /// - Returns: 支持链式调用的View
    func onPlayManTimeUpdate(
        _ handler: @escaping (TimeInterval, Double) -> Void
    ) -> some View {
        self.onReceive(
            NotificationCenter.default.publisher(for: MagicPlayMan.NotificationName.timeUpdate),
            perform: { notification in
                if let currentTime = notification.userInfo?["currentTime"] as? TimeInterval,
                   let progress = notification.userInfo?["progress"] as? Double {
                    handler(currentTime, progress)
                }
            }
        )
    }

    /// 监听播放资源变更通知
    /// - Parameter handler: 处理闭包，参数为 asset: URL?
    /// - Returns: 支持链式调用的View
    func onPlayManAssetChanged(
        _ handler: @escaping (URL?) -> Void
    ) -> some View {
        self.onReceive(
            NotificationCenter.default.publisher(for: MagicPlayMan.NotificationName.assetChanged),
            perform: { notification in
                let asset = notification.userInfo?["asset"] as? URL
                handler(asset)
            }
        )
    }

    /// 监听播放状态变更通知
    /// - Parameter handler: 处理闭包，参数为 isPlaying: Bool
    /// - Returns: 支持链式调用的View
    func onPlayManStateChanged(
        _ handler: @escaping (Bool) -> Void
    ) -> some View {
        self.onReceive(
            NotificationCenter.default.publisher(for: MagicPlayMan.NotificationName.stateChanged),
            perform: { notification in
                let isPlaying = notification.userInfo?["isPlaying"] as? Bool ?? false
                handler(isPlaying)
            }
        )
    }

    /// 监听播放时长变更通知
    /// - Parameter handler: 处理闭包，参数为 duration: TimeInterval
    /// - Returns: 支持链式调用的View
    func onPlayManDurationChanged(
        _ handler: @escaping (TimeInterval) -> Void
    ) -> some View {
        self.onReceive(
            NotificationCenter.default.publisher(for: MagicPlayMan.NotificationName.durationChanged),
            perform: { notification in
                let duration = notification.userInfo?["duration"] as? TimeInterval ?? 0
                handler(duration)
            }
        )
    }
}