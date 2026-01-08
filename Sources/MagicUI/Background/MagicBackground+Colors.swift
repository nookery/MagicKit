import SwiftUI

extension MagicBackground {
    public static var colorRed: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "FF0000").opacity(0.7),
                Color(hex: "CC0000").opacity(0.7),
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .background(.ultraThinMaterial)
        .ignoresSafeArea()
    }

    public static var colorBlue: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "0000FF").opacity(0.7),
                Color(hex: "0000CC").opacity(0.7),
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .background(.ultraThinMaterial)
        .ignoresSafeArea()
    }

    public static var colorGreen: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "00FF00").opacity(0.7),
                Color(hex: "00CC00").opacity(0.7),
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .background(.ultraThinMaterial)
        .ignoresSafeArea()
    }

    public static var colorYellow: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "FFFF00").opacity(0.7),
                Color(hex: "CCCC00").opacity(0.7),
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .background(.ultraThinMaterial)
        .ignoresSafeArea()
    }

    public static var colorPurple: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "800080").opacity(0.7),
                Color(hex: "660066").opacity(0.7),
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .background(.ultraThinMaterial)
        .ignoresSafeArea()
    }

    public static var colorOrange: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "FFA500").opacity(0.7),
                Color(hex: "CC8400").opacity(0.7),
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .background(.ultraThinMaterial)
        .ignoresSafeArea()
    }

    public static var colorPink: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "FFC0CB").opacity(0.7),
                Color(hex: "FF99A8").opacity(0.7),
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .background(.ultraThinMaterial)
        .ignoresSafeArea()
    }

    public static var colorBrown: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "A52A2A").opacity(0.7),
                Color(hex: "8B2222").opacity(0.7),
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .background(.ultraThinMaterial)
        .ignoresSafeArea()
    }

    public static var colorGray: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "808080").opacity(0.7),
                Color(hex: "666666").opacity(0.7),
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .background(.ultraThinMaterial)
        .ignoresSafeArea()
    }

    public static var colorTeal: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "008080").opacity(0.7),
                Color(hex: "006666").opacity(0.7),
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .background(.ultraThinMaterial)
        .ignoresSafeArea()
    }
}

#Preview("Color Themes") {
    TabView {
        // 颜色主题
        ScrollView {
            VStack(spacing: 20) {
                Text("颜色主题")
                    .font(.headline)
                    .padding(.top)

                Group {
                    BackgroundPreviewItem(
                        background: AnyView(MagicBackground.colorRed),
                        title: "Red"
                    )

                    BackgroundPreviewItem(
                        background: AnyView(MagicBackground.colorBlue),
                        title: "Blue"
                    )

                    BackgroundPreviewItem(
                        background: AnyView(MagicBackground.colorGreen),
                        title: "Green"
                    )

                    BackgroundPreviewItem(
                        background: AnyView(MagicBackground.colorYellow),
                        title: "Yellow",
                        textColor: .primary
                    )

                    BackgroundPreviewItem(
                        background: AnyView(MagicBackground.colorPurple),
                        title: "Purple"
                    )
                }

                Group {
                    BackgroundPreviewItem(
                        background: AnyView(MagicBackground.colorOrange),
                        title: "Orange",
                        textColor: .primary
                    )

                    BackgroundPreviewItem(
                        background: AnyView(MagicBackground.colorPink),
                        title: "Pink",
                        textColor: .primary
                    )

                    BackgroundPreviewItem(
                        background: AnyView(MagicBackground.colorBrown),
                        title: "Brown"
                    )

                    BackgroundPreviewItem(
                        background: AnyView(MagicBackground.colorGray),
                        title: "Gray"
                    )

                    BackgroundPreviewItem(
                        background: AnyView(MagicBackground.colorTeal),
                        title: "Teal"
                    )
                }
            }
            .padding()
        }

        .tabItem {
            Image(systemName: "paintpalette.fill")
            Text("颜色")
        }
    }
}

// MARK: - View Extensions
extension View {
/// 应用红色背景效果
    public func inMagicBackgroundColorRed(_ opacity: Double = 1.0) -> some View {
        self.background(MagicBackground.colorRed.opacity(opacity))
    }
    
/// 应用蓝色背景效果
    public func inMagicBackgroundColorBlue(_ opacity: Double = 1.0) -> some View {
        self.background(MagicBackground.colorBlue.opacity(opacity))
    }
    
/// 应用绿色背景效果
    public func inMagicBackgroundColorGreen(_ opacity: Double = 1.0) -> some View {
        self.background(MagicBackground.colorGreen.opacity(opacity))
    }
    
/// 应用黄色背景效果
    public func inMagicBackgroundColorYellow(_ opacity: Double = 1.0) -> some View {
        self.background(MagicBackground.colorYellow.opacity(opacity))
    }
    
/// 应用紫色背景效果
    public func inMagicBackgroundColorPurple(_ opacity: Double = 1.0) -> some View {
        self.background(MagicBackground.colorPurple.opacity(opacity))
    }
    
/// 应用橙色背景效果
    public func inMagicBackgroundColorOrange(_ opacity: Double = 1.0) -> some View {
        self.background(MagicBackground.colorOrange.opacity(opacity))
    }
    
/// 应用粉色背景效果
    public func inMagicBackgroundColorPink(_ opacity: Double = 1.0) -> some View {
        self.background(MagicBackground.colorPink.opacity(opacity))
    }
    
/// 应用棕色背景效果
    public func inMagicBackgroundColorBrown(_ opacity: Double = 1.0) -> some View {
        self.background(MagicBackground.colorBrown.opacity(opacity))
    }
    
/// 应用灰色背景效果
    public func inMagicBackgroundColorGray(_ opacity: Double = 1.0) -> some View {
        self.background(MagicBackground.colorGray.opacity(opacity))
    }
    
/// 应用青色背景效果
    public func inMagicBackgroundColorTeal(_ opacity: Double = 1.0) -> some View {
        self.background(MagicBackground.colorTeal.opacity(opacity))
    }
}
