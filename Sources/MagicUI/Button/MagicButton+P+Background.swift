import SwiftUI

#if DEBUG
    struct BackgroundColorButtonsPreview: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("背景色变体")
                .font(.headline)

            VStack(spacing: 16) {
                Text("基础颜色").font(.subheadline)
                HStack(spacing: 16) {
                    MagicButton(icon: "star")
                        .magicTitle("Blue")
                        .magicBackgroundColor(.blue)

                    MagicButton(icon: "heart")
                        .magicTitle("Red")
                        .magicBackgroundColor(.red)

                    MagicButton(icon: "leaf")
                        .magicTitle("Green")
                        .magicBackgroundColor(.green)
                }
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(spacing: 16) {
                Text("不同形状").font(.subheadline)
                HStack(spacing: 16) {
                    MagicButton(icon: "star")
                        .magicShape(.circle)
                        .magicBackgroundColor(.purple)

                    MagicButton(icon: "star")
                        .magicShape(.roundedSquare)
                        .magicBackgroundColor(.orange)

                    MagicButton(icon: "star")
                        .magicTitle("Capsule")
                        .magicShape(.capsule)
                        .magicBackgroundColor(.mint)
                }
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(spacing: 16) {
                Text("组合效果").font(.subheadline)
                HStack(spacing: 16) {
                    MagicButton(icon: "star")
                        .magicTitle("Primary")
                        .magicStyle(.primary)
                        .magicBackgroundColor(.blue)

                    MagicButton(icon: "star")
                        .magicTitle("Secondary")
                        .magicStyle(.secondary)
                        .magicBackgroundColor(.green)

                    MagicButton(icon: "star")
                        .magicTitle("Disabled")
                        .magicDisabled("Disabled with background")
                        .magicBackgroundColor(.red)
                }
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(spacing: 16) {
                Text("自定义背景").font(.subheadline)
                HStack(spacing: 16) {
                    MagicButton(icon: "sun.max")
                        .magicTitle("Dawn")
                        .magicBackground(MagicBackground.dawnSky)

                    MagicButton(icon: "cloud.bolt")
                        .magicTitle("Storm")
                        .magicBackground(MagicBackground.stormyHeaven)

                    MagicButton(icon: "sunset")
                        .magicTitle("Sunset")
                        .magicBackground(MagicBackground.sunsetGlow)
                }
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(spacing: 16) {
                Text("渐变背景").font(.subheadline)
                HStack(spacing: 16) {
                    MagicButton(icon: "star")
                        .magicTitle("Linear")
                        .magicBackground(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    MagicButton(icon: "star")
                        .magicTitle("Angular")
                        .magicBackground(
                            AngularGradient(
                                colors: [.red, .orange, .yellow, .green, .blue, .purple, .red],
                                center: .center
                            )
                        )

                    MagicButton(icon: "star")
                        .magicTitle("Radial")
                        .magicBackground(
                            RadialGradient(
                                colors: [.mint, .cyan],
                                center: .center,
                                startRadius: 0,
                                endRadius: 50
                            )
                        )
                }
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding()
    }
}
#endif

#if DEBUG
#Preview("Background") {
    BackgroundColorButtonsPreview()
}
#endif
