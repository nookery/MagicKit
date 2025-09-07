import SwiftUI

/// MagicContainer的工具栏视图
struct MagicContainerToolbar: View {
    @Binding var isDarkMode: Bool
    var captureAction: () -> Void
    var appStoreCaptureAction: () -> Void
    var macAppStoreCaptureAction: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {            
            Spacer()
            
            // MARK: macOS App Store Screenshot Button
            Button(action: {
                macAppStoreCaptureAction()
            }) {
                HStack {
                    Image(systemName: "laptopcomputer")
                    Text("macOS App Store")
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
            }
            .buttonStyle(.bordered)
            
            // MARK: App Store Screenshot Button
            Button(action: {
                appStoreCaptureAction()
            }) {
                HStack {
                    Image(systemName: "camera.aperture")
                    Text("iOS App Store")
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
            }
            .buttonStyle(.bordered)
            
            // MARK: Screenshot Button
            Button(action: {
                captureAction()
            }) {
                HStack {
                    Image(systemName: "camera")
                    Text("截图")
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
            }
            .buttonStyle(.bordered)
            
            // MARK: Theme Toggle Button
            Button(action: {
                isDarkMode.toggle()
            }) {
                Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                    .padding(8)
            }
            .buttonStyle(.bordered)
            .clipShape(Circle())
        }
        .padding(.horizontal)
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(Color.primary.opacity(0.05))
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    MagicContainerToolbar(
        isDarkMode: .constant(false),
        captureAction: {},
        appStoreCaptureAction: {},
        macAppStoreCaptureAction: {}
    )
}
#endif
