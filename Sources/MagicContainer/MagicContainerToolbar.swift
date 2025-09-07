import SwiftUI

/// MagicContainer的工具栏视图
struct MagicContainerToolbar: View {
    @Binding var isDarkMode: Bool
    var captureAction: () -> Void
    var appStoreCaptureAction: () -> Void
    var macAppStoreCaptureAction: () -> Void
    var containerSize: CGSize?
    
    var body: some View {
        GeometryReader { proxy in
            let height = proxy.size.height
            VStack(spacing: 0) {
                // Top row: 70%
                HStack(spacing: 4) {
                    Spacer()

                    // MARK: macOS App Store Screenshot Button
                    Button(action: {
                        macAppStoreCaptureAction()
                    }) {
                        HStack {
                            Image(systemName: "laptopcomputer")
                            Text("macOS App Store")
                        }
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
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(.bordered)

                    // MARK: Theme Toggle Button
                    Button(action: {
                        isDarkMode.toggle()
                    }) {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                            .padding(4)
                    }
                    .buttonStyle(.bordered)
                    .clipShape(Circle())
                    
                    Spacer()
                }
                .padding(.horizontal)
                .frame(height: height * 0.7)
                .frame(maxWidth: .infinity)

                // Bottom row: 30%
                HStack {
                    Spacer()
                    if let size = containerSize {
                        Label("\(Int(size.width)) x \(Int(size.height))", systemImage: "ruler")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    } else {
                        EmptyView()
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .frame(height: height * 0.3)
                .frame(maxWidth: .infinity)
                .background(Color.primary.opacity(0.03))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
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

#Preview("MacBook 13 - 20%") {
    Text("Hello, World!")
        .padding()
        .inMagicContainer(.macBook13_20Percent)
}
#endif
