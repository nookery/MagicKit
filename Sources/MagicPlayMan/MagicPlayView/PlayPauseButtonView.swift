import MagicCore
import SwiftUI
import MagicUI

/// 播放/暂停按钮视图
/// 
/// 这是一个自观察的按钮视图，会自动监听 MagicPlayMan 的播放状态变化。
/// 根据当前状态显示播放图标或暂停图标，并自动更新禁用状态。
/// 
/// ## 特性
/// - 自动响应播放状态变化
/// - 智能禁用状态管理
/// - 支持自定义按钮尺寸
/// - 使用 MagicButton 的简单样式
/// 
/// ## 使用示例
/// ```swift
/// PlayPauseButtonView(man: playMan, size: .large)
/// ```
/// 
/// - Parameters:
///   - man: MagicPlayMan 实例，用于监听播放状态和触发播放控制
///   - size: 按钮尺寸，默认为 .regular
struct PlayPauseButtonView: View {
    // 精简订阅：只订阅按钮所需的状态，避免不相关变化触发刷新
    @ObservedObject var man: MagicPlayMan
    let size: MagicButton.Size

    var body: some View {
        MagicButton.simple(
            icon: man.state == .playing ? .iconPauseFill : .iconPlayFill,
            style: .primary,
            size: size,
            shape: .circle,
            disabledReason: !man.hasAsset ? "No media loaded" :
                man.state.isLoading ? "Loading..." : nil,
            action: man.toggle
        )
        .magicId(man.playPauseButtonId)
    }
}

// MARK: - Preview

#Preview("MagicPlayMan") {
    MagicPlayMan
        .PreviewView()
}


