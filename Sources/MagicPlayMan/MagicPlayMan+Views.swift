import MagicCore
import SwiftUI

/// MagicPlayMan 的视图相关功能扩展
/// 提供了一系列用于创建播放器界面组件的方法
public extension MagicPlayMan {
    /// 创建音频播放视图
    /// - Returns: 音频播放视图
    private func makeAudioView(url: URL) -> some View {
        AudioPlayerView(
            title: url.title,
            url: url
        )
    }

    /// 创建空状态视图
    /// - Returns: 空状态视图
    private func makeEmptyView() -> some View {
        AudioPlayerView(
            title: "No Media Selected",
            artist: "Select a media file to play"
        )
    }

    /// 创建播放状态视图
    /// - Returns: 返回一个显示播放器当前状态的视图，包括：
    /// - 播放/暂停状态
    /// - 当前播放资源的标题
    func makeStateView() -> some View {
        state.makeStateView(assetTitle: currentAsset?.title)
    }

    /// 创建日志视图
    /// - Returns: 返回一个显示播放器日志信息的视图
    /// 用于展示播放器的事件历史和操作记录
    func makeLogView() -> some View {
        logger.logView(title: "MagicPlayMan-Logs")
    }

    /// 创建播放列表视图
    /// - Returns: 返回一个播放列表视图，根据列表状态自动适配：
    /// - 当列表为空时，显示空列表提示视图
    /// - 当列表有内容时，显示播放列表内容视图
    func makePlaylistView() -> some View {
        Group {
            if items.isEmpty {
                EmptyPlaylistView()
            } else {
                PlaylistContentView(playMan: self)
            }
        }
    }

    /// 创建媒体资源视图
    /// - Returns: 返回一个根据当前媒体资源类型自动适配的视图：
    /// - 当没有加载资源时，返回空视图
    /// - 当资源为视频时，返回视频播放视图
    /// - 当资源为音频时，返回音频播放视图，包括了音频的标题
    func makeMediaView() -> some View {
        return Group {
            if currentAsset == nil {
                makeEmptyView()
            } else if currentAsset!.isAudio {
                makeAudioView(url: currentAsset!)
            } else {
                makeVideoView()
            }
        }
    }

    /// 创建视频播放视图
    /// - Returns: 视频播放视图
    private func makeVideoView() -> some View {
        VideoPlayerView(player: player)
    }

    /// 创建播放进度条视图
    /// 
    /// 这是一个自观察的进度条视图，会自动监听播放进度状态变化。
    /// 提供播放进度显示和拖动控制功能，支持实时进度更新和用户交互。
    /// 
    /// - Returns: 自观察的播放进度条视图
    func makeProgressView() -> some View {
        MagicPlayProgressView(man: self)
    }

    /// 创建支持的媒体格式视图
    /// - Returns: 返回一个展示所有支持的媒体格式的视图
    /// 用于向用户展示播放器支持播放哪些类型的媒体文件
    func makeSupportedFormatsView() -> some View {
        FormatInfoView(formats: SupportedFormat.allFormats)
    }

    /// 创建订阅者列表视图
    /// - Returns: 返回订阅者列表弹窗内容
    func makeSubscribersView() -> some View {
        SubscribersView(subscribers: events.subscribers)
            .frame(width: 300, height: 400)
            .padding()
    }

    /// 创建主要展示视图
    /// - Returns: 返回一个根据当前媒体资源类型自动适配的主要展示视图：
    /// - 当资源为音频时，显示音频缩略图，不包括音频的标题和艺术家
    /// - 当资源为视频时，显示视频播放视图
    func makeHeroView(verbose: Bool = false, defaultImage: Image? = nil) -> some View {
        Group {
            if currentAsset == nil {
                makeEmptyView()
            } else if currentAsset!.isAudio {
                ThumbnailView(
                    url: currentAsset!,
                    verbose: verbose,
                    defaultImage: defaultImage
                )
            } else {
                makeVideoView()
            }
        }
    }

    func makeHeroView<Content: View>(verbose: Bool = false, @ViewBuilder defaultView: () -> Content) -> some View {
        Group {
            if currentAsset == nil {
                makeEmptyView()
            } else if currentAsset!.isAudio {
                ThumbnailView(
                    url: currentAsset!,
                    verbose: verbose,
                    defaultView: defaultView
                )
            } else {
                makeVideoView()
            }
        }
    }
}

// MARK: - Preview

#Preview("MagicPlayMan") {
    MagicPlayMan
        .PreviewView()
}
