import MagicCore
import SwiftUI
import MagicUI

/// 喜欢按钮视图
/// 
/// 这是一个自观察的按钮视图，会自动监听 MagicPlayMan 的喜欢状态变化。
/// 根据当前媒体资源的喜欢状态显示不同的图标和样式，支持喜欢/取消喜欢操作。
/// 
/// ## 特性
/// - 自动响应喜欢状态变化
/// - 动态图标和样式切换（实心/空心爱心）
/// - 支持自定义按钮尺寸、样式、形状等属性
/// - 智能禁用状态管理
/// - 异步操作处理
/// - 自动分配唯一标识符
/// 
/// ## 使用示例
/// ```swift
/// // 基础用法
/// LikeButtonView(man: playMan, size: .large)
/// 
/// // 自定义样式
/// LikeButtonView(man: playMan, size: .large, style: .success, shape: .circle)
/// 
/// // 悬停时显示形状
/// LikeButtonView(man: playMan, shapeVisibility: .onHover)
/// ```
/// 
/// - Parameters:
///   - man: MagicPlayMan 实例，用于监听喜欢状态和触发喜欢操作
///   - size: 按钮尺寸，默认为 .regular
///   - style: 按钮样式，默认为 nil（使用默认样式：喜欢时为 .primary，不喜欢时为 .secondary）
///   - shape: 按钮形状，默认为 .roundedSquare
///   - shapeVisibility: 形状显示时机，默认为 .always
struct LikeButtonView: View {
    @ObservedObject var man: MagicPlayMan
    let size: MagicButton.Size
    let style: MagicButton.Style?
    let shape: MagicButton.Shape
    let shapeVisibility: MagicButton.ShapeVisibility
    
    /// 初始化方法
    init(
        man: MagicPlayMan,
        size: MagicButton.Size = .regular,
        style: MagicButton.Style? = nil,
        shape: MagicButton.Shape = .roundedSquare,
        shapeVisibility: MagicButton.ShapeVisibility = .always
    ) {
        self.man = man
        self.size = size
        self.style = style
        self.shape = shape
        self.shapeVisibility = shapeVisibility
    }

    var body: some View {
        MagicButton(
            icon: man.isCurrentAssetLiked ? "heart.fill" : "heart",
            style: style ?? (man.isCurrentAssetLiked ? .primary : .secondary),
            size: size,
            shape: shape,
            shapeVisibility: shapeVisibility,
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
}


