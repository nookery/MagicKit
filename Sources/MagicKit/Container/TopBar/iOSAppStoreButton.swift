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
