import SwiftUI

extension MagicContainer {
    /// 工具栏组件
    struct Toolbar: View {
        @Binding var isDarkMode: Bool
        @Environment(\.containerSize) private var containerSize
        @Environment(\.containerScale) private var scale
        @Environment(\.captureActions) private var actions

        var body: some View {
            GeometryReader { proxy in
                let height = proxy.size.height
                VStack(spacing: 0) {
                    // Top row
                    HStack(spacing: 4) {
                        Spacer()

                        XcodeIconButton(
                            action: actions.xcodeIcons,
                            containerSize: containerSize
                        )

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
                    .frame(height: height * 0.7)
                    .frame(maxWidth: .infinity)

                    // Bottom
                    SizeInfoView(
                        containerSize: containerSize,
                        scale: scale
                    )
                    .frame(height: height * 0.3)
                    .frame(maxWidth: .infinity)
                }
                .infinite()
                .background(Color.secondary.opacity(0.1))
            }
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
