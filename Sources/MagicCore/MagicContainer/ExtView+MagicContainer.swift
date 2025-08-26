import SwiftUI

public extension View {
    /// 为预览视图添加通用容器
    func inMagicContainer(containerHeight: CGFloat = 750) -> some View {
        MagicContainer(containerHeight: containerHeight) {
            self
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview("MagicThemePreviewPreview") {
    MagicContainerPreview()
}
#endif
