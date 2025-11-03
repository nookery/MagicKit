import MagicCore
import SwiftUI
import MagicUI

/// 日志按钮视图
/// 
/// 这是一个自观察的按钮视图，会自动监听 MagicPlayMan 的日志状态变化。
/// 提供播放器日志查看功能，通过弹窗展示播放器的操作历史和调试信息。
/// 
/// ## 特性
/// - 自动响应日志状态变化
/// - 弹窗式日志信息展示
/// - 支持自定义按钮尺寸
/// - 使用 MagicButton 的默认样式
/// - 集成日志管理视图
/// - 大尺寸弹窗展示（800x400）
/// 
/// ## 使用示例
/// ```swift
/// LogButtonView(man: playMan, size: .large)
/// ```
/// 
/// - Parameters:
///   - man: MagicPlayMan 实例，用于获取播放器日志信息
///   - size: 按钮尺寸，默认为 .regular
struct LogButtonView: View {
    @ObservedObject var man: MagicPlayMan
    let size: MagicButton.Size

    var body: some View {
        MagicButton(
            icon: .iconTerminal,
            size: size,
            popoverContent: AnyView(
                man.makeLogView()
                    .frame(width: 800, height: 400)
            )
        )
    }
}

// MARK: - Preview

#Preview("MagicPlayMan") {
    MagicPlayMan
        .PreviewView()
}


