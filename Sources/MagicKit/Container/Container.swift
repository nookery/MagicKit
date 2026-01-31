import Foundation
import MagicAlert
import SwiftUI
#if os(macOS)
    import AppKit
#endif

// MARK: - Environment Keys

private struct ContainerSizeKey: EnvironmentKey {
    static let defaultValue: CGSize = .zero
}

private struct ContainerScaleKey: EnvironmentKey {
    static let defaultValue: CGFloat = 1.0
}

private struct CaptureActionsKey: EnvironmentKey {
    static let defaultValue: CaptureActions = CaptureActions(
        capture: {},
        iOSAppStore: {},
        macOSAppStore: {}
    )
}

private struct IsDarkModeKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

struct CaptureActions {
    let capture: () -> Void
    let iOSAppStore: () -> Void
    let macOSAppStore: () -> Void
}

extension EnvironmentValues {
    var containerSize: CGSize {
        get { self[ContainerSizeKey.self] }
        set { self[ContainerSizeKey.self] = newValue }
    }

    var containerScale: CGFloat {
        get { self[ContainerScaleKey.self] }
        set { self[ContainerScaleKey.self] = newValue }
    }

    var captureActions: CaptureActions {
        get { self[CaptureActionsKey.self] }
        set { self[CaptureActionsKey.self] = newValue }
    }

    var isDarkMode: Bool {
        get { self[IsDarkModeKey.self] }
        set { self[IsDarkModeKey.self] = newValue }
    }
}

/// 视图容器，提供多种实用功能
struct MagicContainer<Content: View>: View {
    // MARK: - Properties

    let content: Content
    let containerHeight: CGFloat
    let containerWidth: CGFloat
    let scale: CGFloat
    let toolBarHeight: CGFloat = 100
    let bottomPadding: CGFloat = 10

    @Environment(\.colorScheme) private var systemColorScheme
    @State private var isDarkMode: Bool = false

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

    // MARK: - Body

    public var body: some View {
        // MARK: Content Layer

        VStack(spacing: 0) {
            // MARK: Toolbar

            Toolbar(isDarkMode: $isDarkMode)
                .frame(height: toolBarHeight)
                .frame(maxWidth: .infinity)

            // MARK: Content Area

            content.frame(width: containerWidth, height: containerHeight)
                .dashedBorder()
                .scaleEffect(scale)
                .frame(width: containerWidth * scale, height: containerHeight * scale)

            Spacer(minLength: bottomPadding)
        }
        .background(.background)
        .environment(\.colorScheme, isDarkMode ? .dark : .light)
        .environment(\.containerSize, CGSize(width: containerWidth, height: containerHeight))
        .environment(\.containerScale, scale)
        .environment(\.captureActions, CaptureActions(
            capture: captureView,
            iOSAppStore: captureAppStoreView,
            macOSAppStore: captureMacAppStoreView
        ))
        .frame(width: containerWidth * scale, height: toolBarHeight + bottomPadding + containerHeight * scale)
        .onAppear {
            // 初始化时跟随系统主题
            isDarkMode = systemColorScheme == .dark
        }
        .withMagicToast()
    }

    // MARK: - Toolbar

    private struct Toolbar: View {
        @Binding var isDarkMode: Bool
        @Environment(\.containerSize) private var containerSize
        @Environment(\.containerScale) private var scale
        @Environment(\.captureActions) private var actions

        var body: some View {
            GeometryReader { proxy in
                let height = proxy.size.height
                VStack(spacing: 0) {
                    // Top row: 50%
                    HStack(spacing: 4) {
                        Spacer()

                        MacAppStoreButton(
                            action: actions.macOSAppStore,
                            containerSize: containerSize
                        )

                        iOSAppStoreButton(
                            action: actions.iOSAppStore,
                            containerSize: containerSize
                        )

                        ScreenshotButton(action: actions.capture)

                        ThemeToggleButton(isDarkMode: $isDarkMode)

                        Spacer()
                    }
                    .padding(.horizontal)
                    .frame(height: height * 0.5)
                    .frame(maxWidth: .infinity)

                    // Bottom row: 50%
                    SizeInfoView(
                        containerSize: containerSize,
                        scale: scale
                    )
                    .frame(height: height * 0.5)
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color.primary.opacity(0.05))
        }
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
