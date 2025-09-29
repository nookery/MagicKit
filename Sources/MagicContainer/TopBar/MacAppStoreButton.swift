import SwiftUI

/// macOS App Store 截图按钮组件
struct MacAppStoreButton: View {
    let action: () -> Void
    let containerSize: CGSize
    
    var body: some View {
        if containerSize.isWidthGreaterThanHeight {
            Button(action: action) {
                HStack {
                    Image(systemName: "laptopcomputer")
                    Text("macOS App Store")
                }
                .padding(.vertical, 4)
            }
            .buttonStyle(.bordered)
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview("iPhone") {
    MagicContainerPreview.iPhonePreview
}
#endif
