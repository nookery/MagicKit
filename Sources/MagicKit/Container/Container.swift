import Foundation
import MagicAlert
import SwiftUI
#if os(macOS)
    import AppKit
#endif

/// 视图容器，提供多种实用功能
struct MagicContainer<Content: View>: View {
    // MARK: - Properties

    let content: Content
    let containerHeight: CGFloat
    let containerWidth: CGFloat
    let scale: CGFloat
    let toolBarHeight: CGFloat = 100
    let tipsBarHeight: CGFloat = 60

    @Environment(\.colorScheme) private var systemColorScheme
    @State var isDarkMode: Bool = false

    // MARK: - Initialization

    /// 创建容器
    /// - Parameters:
    ///   - containerSize: 容器尺寸，默认为 500x750
    ///   - scale: 缩放比例，默认为 1.0
    ///   - content: 要预览的内容视图
    public init(
        _ containerSize: CGSize = CGSize(width: 500, height: 750),
        scale: CGFloat = 1.0,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.containerHeight = containerSize.height
        self.containerWidth = containerSize.width
        self.scale = scale
    }

    public var body: some View {
        VStack(spacing: 0) {
            toolBar

            content.frame(width: containerWidth, height: containerHeight)
                .dashedBorder()
                .scaleEffect(scale)
                .frame(width: containerWidth * scale, height: containerHeight * scale)

            tipsBar
                .frame(height: tipsBarHeight)
        }
        .background(.background)
        .environment(\.colorScheme, isDarkMode ? .dark : .light)
        .frame(width: containerWidth * scale, height: toolBarHeight + tipsBarHeight + containerHeight * scale)
        .onAppear {
            // 初始化时跟随系统主题
            isDarkMode = systemColorScheme == .dark
        }
        .withMagicToast()
    }
}

#if DEBUG
    import SwiftUI

    #Preview("iMac 27 - 缩放") {
        Text("Hello, World!")
            .font(.system(size: 400))
            .magicCentered()
            .background(.indigo.opacity(0.3))
            .inMagicContainer(.iMac27, scale: 0.1)
    }
#endif
