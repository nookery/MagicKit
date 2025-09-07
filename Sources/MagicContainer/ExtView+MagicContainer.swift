import SwiftUI

public extension View {
    /// 为预览视图添加通用容器（使用CGSize指定尺寸）
    /// - Parameters:
    ///   - containerSize: 容器尺寸，默认为 500x750
    /// - Returns: MagicContainer 视图
    func inMagicContainer(_ containerSize: CGSize = CGSize(width: 500, height: 750)) -> some View {
        MagicContainer(containerSize) {
            self
        }
    }
}
