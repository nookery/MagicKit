import SwiftUI

/// 悬停效果扩展预览
struct HoverExtensionPreview: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Hover Scale Examples")
                .font(.title2)
                .fontWeight(.semibold)
                .withDivider(spacing: 10)

            VStack(spacing: 20) {
                Text("Hover over these items")
                    .font(.headline)

                HStack(spacing: 20) {
                    Text("scale-105")
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .roundedMedium()
                        .hoverScale(105)

                    Text("scale-110")
                        .padding()
                        .background(.green)
                        .foregroundColor(.white)
                        .roundedMedium()
                        .hoverScale(110)

                    Text("scale-125")
                        .padding()
                        .background(.orange)
                        .foregroundColor(.white)
                        .roundedMedium()
                        .hoverScale(125)
                }

                HStack(spacing: 20) {
                    Circle()
                        .fill(.purple)
                        .frame(width: 60, height: 60)
                        .hoverScale(115)

                    RoundedRectangle(cornerRadius: 10)
                        .fill(.pink)
                        .frame(width: 60, height: 60)
                        .hoverScale(120)
                }

                HStack(spacing: 15) {
                    Image(systemName: "star.fill")
                        .font(.title)
                        .foregroundColor(.yellow)
                        .hoverScale(130)

                    Image(systemName: "heart.fill")
                        .font(.title)
                        .foregroundColor(.red)
                        .hoverScale(125)

                    Image(systemName: "circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                        .hoverScale(110)
                }
            }

            Text("Custom Duration")
                .font(.headline)
                .padding(.top, 10)

            HStack(spacing: 20) {
                Text("Fast (0.1s)")
                    .padding()
                    .background(.cyan)
                    .foregroundColor(.white)
                    .roundedMedium()
                    .hoverScale(115, duration: 0.1)

                Text("Slow (0.5s)")
                    .padding()
                    .background(.indigo)
                    .foregroundColor(.white)
                    .roundedMedium()
                    .hoverScale(115, duration: 0.5)
            }

            Text("Combined with other effects")
                .font(.headline)
                .padding(.top, 10)

            VStack(spacing: 15) {
                HStack {
                    Image(systemName: "hand.tap")
                    Text("Click me")
                }
                .padding()
                .inButtonWithAction {}
                .hoverScale(108)

                Text("Card with hover")
                    .padding()
                    .inCardUltraThin()
                    .hoverScale(105)
            }
        }
        .padding()
        .infinite()
        .inScrollView()
    }
}

#if DEBUG
    #Preview("Hover Extensions") {
        HoverExtensionPreview()
            .frame(height: 700)
            .frame(width: 500)
    }
#endif
