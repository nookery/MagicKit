import SwiftUI

public extension View {
    /// 为预览视图添加通用容器
    /// - Parameters:
    ///   - containerHeight: 容器高度，默认为 750
    ///   - containerWidth: 容器宽度，可选
    /// - Returns: MagicContainer 视图
    func inMagicContainer(containerHeight: CGFloat = 750, containerWidth: CGFloat = 500) -> some View {
        MagicContainer(
            containerHeight: containerHeight,
            containerWidth: containerWidth
        ) {
            self
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview("MagicThemePreviewPreview") {
    Text("Hello, World!")
        .padding()
        .inMagicContainer(containerWidth: 500)
}
#endif
