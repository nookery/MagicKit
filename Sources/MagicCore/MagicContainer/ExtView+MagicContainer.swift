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
    
    /// 为预览视图添加通用容器（使用CGSize指定尺寸）
    /// - Parameters:
    ///   - containerSize: 容器尺寸，默认为 500x750
    /// - Returns: MagicContainer 视图
    func inMagicContainer(containerSize: CGSize = CGSize(width: 500, height: 750)) -> some View {
        MagicContainer(containerSize: containerSize) {
            self
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview("MagicContainer - CGSize") {
    Text("Hello, World!")
        .padding()
        .inMagicContainer(containerSize: CGSize(width: 400, height: 600))
}

#Preview("MagicContainer - Traditional") {
    Text("Hello, World!")
        .padding()
        .inMagicContainer(containerWidth: 500)
}
#endif
