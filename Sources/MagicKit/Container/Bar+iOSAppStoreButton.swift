import SwiftUI

/// iOS App Store 截图按钮组件
struct iOSAppStoreButton: View {
    let action: () -> Void
    let containerSize: CGSize
    
    var body: some View {
        if containerSize.isWidthLessThanHeight {
            Button(action: action) {
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
