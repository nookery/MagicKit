import MagicCore
import OSLog
import SwiftUI
import MagicUI

public extension MagicPlayMan {
    /// 自观察版本：播放/暂停按钮视图（推荐外部调用，零负担自动刷新）
    /// 
    /// 这是一个自观察的按钮视图，会自动监听播放状态变化并自动刷新。
    /// 无需外部订阅或手动刷新，推荐在 SwiftUI 视图中使用。
    /// 
    /// - Parameter size: 按钮尺寸，默认为 .regular
    /// - Returns: 自观察的播放/暂停按钮视图
    @MainActor
    @ViewBuilder
    func makePlayPauseButtonView(size: MagicButton.Size = .regular) -> some View {
        PlayPauseButtonView(man: self, size: size)
    }

    /// 获取播放/暂停按钮的动态 ID
    /// 用于在 SwiftUI View 中通过 .id() 修饰符响应状态变化
    var playPauseButtonId: String {
        if self.state.isLoading {
            return "play-pause-button-loading"
        } else if self.state == .playing {
            return "play-pause-button-playing"
        } else if self.state == .paused {
            return "play-pause-button-paused"
        } else if self.state == .stopped {
            return "play-pause-button-stopped"
        } else if case .failed = self.state {
            return "play-pause-button-failed"
        } else {
            return "play-pause-button-idle"
        }
    }

    /// 自观察版本：上一曲按钮视图
    /// 
    /// 这是一个自观察的按钮视图，会自动监听播放列表状态变化。
    /// 根据当前播放位置和播放列表状态智能管理按钮的可用性。
    /// 
    /// - Parameter size: 按钮尺寸，默认为 .regular
    /// - Returns: 自观察的上一曲按钮视图
    @MainActor
    @ViewBuilder
    func makePreviousButtonView(size: MagicButton.Size = .regular) -> some View {
        PreviousButtonView(man: self, size: size)
    }

    /// 自观察版本：下一曲按钮视图
    /// 
    /// 这是一个自观察的按钮视图，会自动监听播放列表状态变化。
    /// 根据当前播放位置和播放列表状态智能管理按钮的可用性。
    /// 
    /// - Parameter size: 按钮尺寸，默认为 .regular
    /// - Returns: 自观察的下一曲按钮视图
    @MainActor
    @ViewBuilder
    func makeNextButtonView(size: MagicButton.Size = .regular) -> some View {
        NextButtonView(man: self, size: size)
    }

    /// 自观察版本：快退按钮视图
    /// 
    /// 这是一个自观察的按钮视图，会自动监听播放状态变化。
    /// 提供快退功能，允许用户快速回退播放进度。
    /// 
    /// - Parameter size: 按钮尺寸，默认为 .regular
    /// - Returns: 自观察的快退按钮视图
    @MainActor
    @ViewBuilder
    func makeRewindButtonView(size: MagicButton.Size = .regular) -> some View {
        RewindButtonView(man: self, size: size)
    }

    /// 自观察版本：快进按钮视图
    /// 
    /// 这是一个自观察的按钮视图，会自动监听播放状态变化。
    /// 提供快进功能，允许用户快速前进播放进度。
    /// 
    /// - Parameter size: 按钮尺寸，默认为 .regular
    /// - Returns: 自观察的快进按钮视图
    @MainActor
    @ViewBuilder
    func makeForwardButtonView(size: MagicButton.Size = .regular) -> some View {
        ForwardButtonView(man: self, size: size)
    }

    /// 自观察版本：播放模式按钮视图
    /// 
    /// 这是一个自观察的按钮视图，会自动监听播放模式状态变化。
    /// 根据当前播放模式显示相应的图标和样式，支持循环、随机等播放模式切换。
    /// 
    /// - Parameter size: 按钮尺寸，默认为 .regular
    /// - Returns: 自观察的播放模式按钮视图
    @MainActor
    @ViewBuilder
    func makePlayModeButtonView(size: MagicButton.Size = .regular) -> some View {
        PlayModeButtonView(man: self, size: size)
    }

    /// 获取播放模式按钮的动态 ID
    /// 用于在 SwiftUI View 中通过 .id() 修饰符响应播放模式变化
    var playModeButtonId: String {
        return "play-mode-button-\(playMode.rawValue)"
    }

    /// 自观察版本：喜欢按钮视图
    /// 
    /// 这是一个自观察的按钮视图，会自动监听喜欢状态变化。
    /// 根据当前媒体资源的喜欢状态显示不同的图标和样式，支持喜欢/取消喜欢操作。
    /// 
    /// - Parameters:
    ///   - size: 按钮尺寸，默认为 .regular
    ///   - style: 按钮样式，默认为 nil（使用默认样式：喜欢时为 .primary，不喜欢时为 .secondary）
    ///   - shape: 按钮形状，默认为 .roundedSquare
    ///   - shapeVisibility: 形状显示时机，默认为 .always
    /// - Returns: 自观察的喜欢按钮视图
    @MainActor
    @ViewBuilder
    func makeLikeButtonView(
        size: MagicButton.Size = .regular,
        style: MagicButton.Style? = nil,
        shape: MagicButton.Shape = .roundedSquare,
        shapeVisibility: MagicButton.ShapeVisibility = .always
    ) -> some View {
        LikeButtonView(
            man: self,
            size: size,
            style: style,
            shape: shape,
            shapeVisibility: shapeVisibility
        )
    }

    /// 获取喜欢按钮的动态 ID
    /// 用于在 SwiftUI View 中通过 .id() 修饰符响应喜欢状态变化
    var likeButtonId: String {
        if !hasAsset {
            return "like-button-no-asset"
        } else if isCurrentAssetLiked {
            return "like-button-liked"
        } else {
            return "like-button-not-liked"
        }
    }

    /// 自观察版本：播放列表按钮视图
    /// 
    /// 这是一个自观察的按钮视图，会自动监听播放列表状态变化。
    /// 提供播放列表查看功能，通过弹窗展示当前播放列表内容。
    /// 
    /// - Parameter size: 按钮尺寸，默认为 .regular
    /// - Returns: 自观察的播放列表按钮视图
    @MainActor
    @ViewBuilder
    func makePlaylistButtonView(size: MagicButton.Size = .regular) -> some View {
        PlaylistButtonView(man: self, size: size)
    }

    /// 自观察版本：播放列表开关按钮视图
    /// 
    /// 这是一个自观察的按钮视图，会自动监听播放列表启用状态变化。
    /// 提供播放列表功能的开启/关闭切换，根据状态显示不同的图标和样式。
    /// 
    /// - Parameter size: 按钮尺寸，默认为 .regular
    /// - Returns: 自观察的播放列表开关按钮视图
    @MainActor
    @ViewBuilder
    func makePlaylistToggleButtonView(size: MagicButton.Size = .regular) -> some View {
        PlaylistToggleButtonView(man: self, size: size)
    }

    /// 获取播放列表切换按钮的动态 ID
    /// 用于在 SwiftUI View 中通过 .id() 修饰符响应播放列表状态变化
    var playlistToggleButtonId: String {
        return "playlist-toggle-button-\(isPlaylistEnabled ? "enabled" : "disabled")"
    }

    /// 自观察版本：订阅者按钮视图
    /// 
    /// 这是一个自观察的按钮视图，会自动监听订阅者状态变化。
    /// 提供订阅者列表查看功能，通过弹窗展示当前注册的事件订阅者信息。
    /// 
    /// - Parameter size: 按钮尺寸，默认为 .regular
    /// - Returns: 自观察的订阅者按钮视图
    @MainActor
    @ViewBuilder
    func makeSubscribersButtonView(size: MagicButton.Size = .regular) -> some View {
        SubscribersButtonView(man: self, size: size)
    }

    /// 自观察版本：支持格式按钮视图
    /// 
    /// 这是一个自观察的按钮视图，会自动监听媒体格式支持状态变化。
    /// 提供支持的媒体格式查看功能，通过弹窗展示播放器支持的所有媒体格式信息。
    /// 
    /// - Parameter size: 按钮尺寸，默认为 .regular
    /// - Returns: 自观察的支持格式按钮视图
    @MainActor
    @ViewBuilder
    func makeSupportedFormatsButtonView(size: MagicButton.Size = .regular) -> some View {
        SupportedFormatsButtonView(man: self, size: size)
    }

    /// 自观察版本：日志按钮视图
    /// 
    /// 这是一个自观察的按钮视图，会自动监听日志状态变化。
    /// 提供播放器日志查看功能，通过弹窗展示播放器的操作历史和调试信息。
    /// 
    /// - Parameter size: 按钮尺寸，默认为 .regular
    /// - Returns: 自观察的日志按钮视图
    @MainActor
    @ViewBuilder
    func makeLogButtonView(size: MagicButton.Size = .regular) -> some View {
        LogButtonView(man: self, size: size)
    }

    /// 创建媒体选择按钮
    /// - Returns: 用于选择媒体资源的按钮
    /// - Note: 按钮会显示当前选中的媒体名称，如果没有选中则显示默认文本
    func makeMediaPickerButton() -> some View {
        MediaPickerButton(
            man: self,
            selectedName: currentURL?.title,
            onSelect: { url in
                Task {
                    await self.play(url)
                }
            }
        )
    }
}

// MARK: - Preview

#Preview("MagicPlayMan") {
    MagicPlayMan.PreviewView()
}

#Preview("Button Views") {
    let man = MagicPlayMan()

    return VStack(spacing: 20) {
        // 媒体选择按钮
        man.makeMediaPickerButton()

        // 播放控制按钮组
        HStack(spacing: 16) {
            man.makePreviousButtonView()
            man.makeRewindButtonView()
            man.makePlayPauseButtonView()
            man.makeForwardButtonView()
            man.makeNextButtonView()
        }

        // 功能按钮组
        HStack(spacing: 16) {
            man.makePlayModeButtonView()
            man.makeLikeButtonView()
            man.makePlaylistButtonView()
            man.makePlaylistToggleButtonView()
        }

        // 工具按钮组
        HStack(spacing: 16) {
            man.makeSubscribersButtonView()
            man.makeSupportedFormatsButtonView()
            man.makeLogButtonView()
        }

        // 不同尺寸的按钮示例
        VStack(spacing: 16) {
            Text("Different Sizes").font(.caption)
            HStack(spacing: 16) {
                man.makeLikeButtonView(size: .small)
                man.makeLikeButtonView(size: .regular)
                man.makeLikeButtonView(size: .large)
            }
        }
    }
    .padding()
}
