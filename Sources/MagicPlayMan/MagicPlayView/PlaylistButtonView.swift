import MagicCore
import SwiftUI
import MagicUI

/// 播放列表按钮视图
/// 
/// 这是一个自观察的按钮视图，会自动监听 MagicPlayMan 的播放列表状态变化。
/// 提供播放列表查看功能，通过弹窗展示当前播放列表内容。
/// 
/// ## 特性
/// - 自动响应播放列表状态变化
/// - 智能禁用状态管理
/// - 支持自定义按钮尺寸
/// - 弹窗式播放列表展示
/// - 使用 MagicButton 的次要样式
/// 
/// ## 使用示例
/// ```swift
/// PlaylistButtonView(man: playMan, size: .large)
/// ```
/// 
/// - Parameters:
///   - man: MagicPlayMan 实例，用于监听播放列表状态和获取播放列表视图
///   - size: 按钮尺寸，默认为 .regular
struct PlaylistButtonView: View {
    @ObservedObject var man: MagicPlayMan
    let size: MagicButton.Size

    var body: some View {
        MagicButton(
            icon: .iconList,
            style: .secondary,
            size: size,
            shape: .circle,
            disabledReason: !man.isPlaylistEnabled ? "Playlist is disabled\nEnable playlist to view and manage tracks" : nil,
            popoverContent: man.isPlaylistEnabled ? AnyView(
                ZStack {
                    man.makePlaylistView()
                        .frame(width: 300, height: 400)
                        .padding()
                }
            ) : nil
        )
    }
}

// MARK: - Preview

#Preview("MagicPlayMan") {
    MagicPlayMan
        .PreviewView()
}


