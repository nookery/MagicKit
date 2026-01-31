import SwiftUI

extension MagicContainer {
    var screenshotButton: some View {
        Button(action: captureView) {
            HStack {
                Image(systemName: "camera")
                Text("截图")
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.bordered)
    }
}
