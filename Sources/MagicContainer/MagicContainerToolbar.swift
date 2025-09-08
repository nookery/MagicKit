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
                // Top row: 70%
                HStack(spacing: 4) {
                    Spacer()

                    // MARK: macOS App Store Screenshot Button

                    if self.containerSize.isWidthGreaterThanHeight {
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
                    }

                    // MARK: App Store Screenshot Button

                    if self.containerSize.isWidthLessThanHeight {
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
                    }

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
                .frame(height: height * 0.5)
                .frame(maxWidth: .infinity)

                // Bottom row: 30%
                VStack(spacing: 4) {
                    HStack {
                        Spacer()
                        if scale != 1.0 {
                            // 显示缩放后的实际尺寸和缩放比例
                            Label("原始尺寸: \(Int(self.containerSize.width)) x \(Int(self.containerSize.height))", systemImage: "ruler")
                                .font(.footnote)
                                .foregroundStyle(.secondary)

                            Text("已缩放到: \(String(format: "%.1f", scale))x")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        } else {
                            // 原始尺寸，无缩放
                            Label("\(Int(self.containerSize.width)) x \(Int(self.containerSize.height))", systemImage: "ruler")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                    }

                    Label("请按原始尺寸设计你的视图", systemImage: "info")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                .frame(height: height * 0.5)
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
    #Preview("MacBook 13 - 20%") {
        Text("Hello, World!")
            .padding()
            .inMagicContainer(.macBook13_20Percent)
    }

    #Preview("iMac 27 - 缩放示例") {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Hello, World!")
                    .font(.system(size: 400))
                    .padding()
                Spacer()
            }
            Spacer()
        }
        .background(.indigo.opacity(0.3))
        .inMagicContainer(.iMac27, scale: 0.1)
    }

    #Preview("MacBook 13 - 缩放示例") {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Hello, World!")
                    .font(.system(size: 200))
                    .padding()
                Spacer()
            }
            Spacer()
        }
        .background(.green.opacity(0.3))
        .inMagicContainer(.macBook13, scale: 0.3)
    }
#endif
