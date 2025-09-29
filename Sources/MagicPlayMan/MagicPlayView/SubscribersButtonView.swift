import MagicCore
import SwiftUI
import MagicUI

/// 订阅者按钮视图
/// 
/// 这是一个自观察的按钮视图，会自动监听 MagicPlayMan 的订阅者状态变化。
/// 提供订阅者列表查看功能，通过弹窗展示当前注册的事件订阅者信息。
/// 
/// ## 特性
/// - 自动响应订阅者状态变化
/// - 弹窗式订阅者列表展示
/// - 支持自定义按钮尺寸
/// - 使用 MagicButton 的次要样式
/// - 集成订阅者管理视图
/// 
/// ## 使用示例
/// ```swift
/// SubscribersButtonView(man: playMan, size: .large)
/// ```
/// 
/// - Parameters:
///   - man: MagicPlayMan 实例，用于监听订阅者状态和获取订阅者视图
///   - size: 按钮尺寸，默认为 .regular
struct SubscribersButtonView: View {
    @ObservedObject var man: MagicPlayMan
    let size: MagicButton.Size

    var body: some View {
        MagicButton(
            icon: .iconPersonGroup,
            style: .secondary,
            size: size,
            shape: .circle,
            popoverContent: AnyView(
                man.makeSubscribersView()
            )
        )
    }
}

// MARK: - Preview

#Preview("MagicPlayMan") {
    MagicPlayMan
        .PreviewView()
        
}


