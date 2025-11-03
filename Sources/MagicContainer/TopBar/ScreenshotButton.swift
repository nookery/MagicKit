import SwiftUI

/// 截图按钮组件
struct ScreenshotButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "camera")
                Text("截图")
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.bordered)
    }
}

// MARK: - Preview

#if DEBUG
#Preview("iPhone") {
    MagicContainerPreview.iPhonePreview
}
#endif
