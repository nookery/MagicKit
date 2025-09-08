import MagicCore
import SwiftUI
import MagicUI

/// 播放模式按钮视图
/// 
/// 这是一个自观察的按钮视图，会自动监听 MagicPlayMan 的播放模式状态变化。
/// 根据当前播放模式显示相应的图标和样式，支持循环、随机等播放模式切换。
/// 
/// ## 特性
/// - 自动响应播放模式状态变化
/// - 动态图标和样式切换
/// - 支持自定义按钮尺寸
/// - 使用 MagicButton 的动态样式（主要/次要）
/// - 自动分配唯一标识符
/// 
/// ## 使用示例
/// ```swift
/// PlayModeButtonView(man: playMan, size: .large)
/// ```
/// 
/// - Parameters:
///   - man: MagicPlayMan 实例，用于监听播放模式状态和触发模式切换
///   - size: 按钮尺寸，默认为 .regular
struct PlayModeButtonView: View {
    @ObservedObject var man: MagicPlayMan
    let size: MagicButton.Size

    var body: some View {
        MagicButton.simple(
            icon: man.playMode.iconName,
            style: man.playMode != .sequence ? .primary : .secondary,
            size: size,
            shape: .circle,
            action: man.togglePlayMode
        )
        .magicId(man.playModeButtonId)
    }
}

// MARK: - Preview

#Preview("MagicPlayMan") {
    MagicPlayMan
        .PreviewView()
        
}


