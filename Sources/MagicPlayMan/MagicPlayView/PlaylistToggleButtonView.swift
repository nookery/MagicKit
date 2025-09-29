import MagicCore
import SwiftUI
import MagicUI

/// 播放列表开关按钮视图
/// 
/// 这是一个自观察的按钮视图，会自动监听 MagicPlayMan 的播放列表启用状态变化。
/// 提供播放列表功能的开启/关闭切换，根据状态显示不同的图标和样式。
/// 
/// ## 特性
/// - 自动响应播放列表启用状态变化
/// - 动态图标和样式切换
/// - 支持自定义按钮尺寸
/// - 异步状态切换操作
/// - 自动分配唯一标识符
/// 
/// ## 使用示例
/// ```swift
/// PlaylistToggleButtonView(man: playMan, size: .large)
/// ```
/// 
/// - Parameters:
///   - man: MagicPlayMan 实例，用于监听播放列表状态和触发开关操作
///   - size: 按钮尺寸，默认为 .regular
struct PlaylistToggleButtonView: View {
    @ObservedObject var man: MagicPlayMan
    let size: MagicButton.Size

    var body: some View {
        MagicButton(
            icon: man.isPlaylistEnabled ? .iconListCircleFill : .iconListCircle,
            style: man.isPlaylistEnabled ? .primary : .secondary,
            size: size,
            shape: .circle,
            action: { [man] completion in
                Task { @MainActor in
                    man.setPlaylistEnabled(!man.isPlaylistEnabled)
                    completion()
                }
            }
        )
        .magicId(man.playlistToggleButtonId)
    }
}

// MARK: - Preview

#Preview("MagicPlayMan") {
    MagicPlayMan
        .PreviewView()
        
}


