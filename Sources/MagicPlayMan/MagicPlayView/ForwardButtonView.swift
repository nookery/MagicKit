import MagicCore
import SwiftUI
import MagicUI

/// 快进按钮视图
/// 
/// 这是一个自观察的按钮视图，会自动监听 MagicPlayMan 的播放状态变化。
/// 提供快进功能，允许用户快速前进播放进度。
/// 
/// ## 特性
/// - 自动响应播放状态变化
/// - 智能禁用状态管理（无媒体、加载中等）
/// - 支持自定义按钮尺寸
/// - 使用 MagicButton 的次要样式
/// - 默认快进 10 秒
/// 
/// ## 使用示例
/// ```swift
/// ForwardButtonView(man: playMan, size: .large)
/// ```
/// 
/// - Parameters:
///   - man: MagicPlayMan 实例，用于监听播放状态和触发快进操作
///   - size: 按钮尺寸，默认为 .regular
struct ForwardButtonView: View {
    @ObservedObject var man: MagicPlayMan
    let size: MagicButton.Size

    var body: some View {
        MagicButton.simple(
            icon: .iconGoforward10,
            style: .secondary,
            size: size,
            shape: .circle,
            disabledReason: !man.hasAsset ? "No media loaded" :
                man.state.isLoading ? "Loading..." : nil,
            action: { man.skipForward() }
        )
    }
}

// MARK: - Preview

#Preview("MagicPlayMan") {
    MagicPlayMan
        .PreviewView()
}


