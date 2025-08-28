import MagicCore
import SwiftUI

/// 喜欢按钮视图
/// 
/// 这是一个自观察的按钮视图，会自动监听 MagicPlayMan 的喜欢状态变化。
/// 根据当前媒体资源的喜欢状态显示不同的图标和样式，支持喜欢/取消喜欢操作。
/// 
/// ## 特性
/// - 自动响应喜欢状态变化
/// - 动态图标和样式切换（实心/空心爱心）
/// - 支持自定义按钮尺寸
/// - 智能禁用状态管理
/// - 异步操作处理
/// - 自动分配唯一标识符
/// 
/// ## 使用示例
/// ```swift
/// LikeButtonView(man: playMan, size: .large)
/// ```
/// 
/// - Parameters:
///   - man: MagicPlayMan 实例，用于监听喜欢状态和触发喜欢操作
///   - size: 按钮尺寸，默认为 .regular
struct LikeButtonView: View {
    @ObservedObject var man: MagicPlayMan
    let size: MagicButton.Size

    var body: some View {
        MagicButton(
            icon: man.isCurrentAssetLiked ? "heart.fill" : "heart",
            style: man.isCurrentAssetLiked ? .primary : .secondary,
            size: size,
            shape: .roundedSquare,
            disabledReason: !man.hasAsset ? "No media loaded" : nil,
            action: { completion in
                Task {
                    await man.toggleLike()
                    completion()
                }
            }
        )
        .magicId(man.likeButtonId)
    }
}

// MARK: - Preview

#Preview("MagicPlayMan") {
    MagicPlayMan
        .PreviewView()
        .inMagicContainer(containerHeight: 1000)
}


