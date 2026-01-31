import SwiftUI

extension MagicContainer {
    var toolBar: some View {
        GeometryReader { proxy in
            let height = proxy.size.height
            VStack(spacing: 0) {
                // Top row
                HStack(spacing: 4) {
                    Spacer()

                    xcodeIconButton

                    macAppStoreButton

                    iOSAppStoreButton

                    screenshotButton

                    themeToggleButton

                    Spacer()
                }
                .padding(.horizontal)
                .frame(height: height * 0.7)
                .frame(maxWidth: .infinity)

                // Bottom
                sizeInfoView
                    .frame(height: height * 0.3)
                    .frame(maxWidth: .infinity)
            }
            .infinite()
            .background(Color.secondary.opacity(0.1))
        }
        .frame(height: toolBarHeight)
        .infiniteWidth()
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

