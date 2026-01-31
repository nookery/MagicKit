import SwiftUI

/// MagicContainer的工具栏视图
struct MagicContainerToolbar: View {
    @Binding var isDarkMode: Bool
    var captureAction: () -> Void
    var appStoreCaptureAction: () -> Void
    var macAppStoreCaptureAction: () -> Void
    var containerSize: CGSize
    var scale: CGFloat = 1.0

    var body: some View {
        GeometryReader { proxy in
            let height = proxy.size.height
            VStack(spacing: 0) {
                // Top row: 50%
                HStack(spacing: 4) {
                    Spacer()

                    MacAppStoreButton(
                        action: macAppStoreCaptureAction,
                        containerSize: containerSize
                    )

                    iOSAppStoreButton(
                        action: appStoreCaptureAction,
                        containerSize: containerSize
                    )

                    ScreenshotButton(action: captureAction)

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
