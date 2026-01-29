import SwiftUI

/// View扩展 - 悬停效果相关
public extension View {
    /// 为视图添加悬停缩放效果
    ///
    /// 当鼠标悬停在视图上时，视图会缩放到指定比例
    ///
    /// ```swift
    /// Text("Hover me")
    ///     .hoverScale(110)
    ///
    /// Image(systemName: "star")
    ///     .hoverScale(125)
    /// ```
    ///
    /// - Parameter scale: 缩放百分比，例如 110 表示 110%（1.1倍）
    /// - Returns: 带悬停缩放效果的视图
    func hoverScale(_ scale: CGFloat) -> some View {
        self.modifier(HoverScaleModifier(scale: scale / 100.0))
    }

    /// 为视图添加悬停缩放效果和动画
    ///
    /// 当鼠标悬停在视图上时，视图会以指定动画缩放到指定比例
    ///
    /// ```swift
    /// Text("Hover me")
    ///     .hoverScale(110, duration: 0.3)
    /// ```
    ///
    /// - Parameters:
    ///   - scale: 缩放百分比，例如 110 表示 110%（1.1倍）
    ///   - duration: 动画持续时间（秒）
    /// - Returns: 带悬停缩放效果的视图
    func hoverScale(_ scale: CGFloat, duration: Double) -> some View {
        self.modifier(HoverScaleModifier(scale: scale / 100.0, duration: duration))
    }
}

#if DEBUG
    #Preview("Hover Extensions") {
        HoverExtensionPreview()
            .frame(height: 700)
            .frame(width: 500)
    }
#endif
