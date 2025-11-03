import MagicCore
import SwiftUI
import MagicUI

/// 支持格式按钮视图
/// 
/// 这是一个自观察的按钮视图，会自动监听 MagicPlayMan 的媒体格式支持状态变化。
/// 提供支持的媒体格式查看功能，通过弹窗展示播放器支持的所有媒体格式信息。
/// 
/// ## 特性
/// - 自动响应媒体格式支持状态变化
/// - 弹窗式格式信息展示
/// - 支持自定义按钮尺寸
/// - 使用 MagicButton 的次要样式
/// - 集成格式信息视图
/// 
/// ## 使用示例
/// ```swift
/// SupportedFormatsButtonView(man: playMan, size: .large)
/// ```
/// 
/// - Parameters:
///   - man: MagicPlayMan 实例，用于获取支持的媒体格式信息
///   - size: 按钮尺寸，默认为 .regular
struct SupportedFormatsButtonView: View {
    @ObservedObject var man: MagicPlayMan
    let size: MagicButton.Size

    var body: some View {
        MagicButton(
            icon: .iconMusicNote,
            style: .secondary,
            size: size,
            shape: .circle,
            popoverContent: AnyView(
                man.makeSupportedFormatsView()
            )
        )
    }
}

// MARK: - Preview

#Preview("MagicPlayMan") {
    MagicPlayMan
        .PreviewView()
        
}


