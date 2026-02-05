import SwiftUI

extension MagicContainer {
    @ViewBuilder
    var iOSAppStoreButton: some View {
        let containerSize = CGSize(width: containerWidth, height: containerHeight)
        if containerSize.isPortrait {
            Button(action: captureAppStoreView) {
                HStack {
                    Image(systemName: "camera.aperture")
                    Text("iOS App Store")
                }
                .padding(.vertical, 4)
            }
            .buttonStyle(.bordered)
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
