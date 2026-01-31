import SwiftUI

extension MagicContainer {
    var sizeInfoView: some View {
        HStack {
            Spacer()
            if scale != 1.0 {
                // 显示缩放后的实际尺寸和缩放比例
                Label("原始尺寸: \(Int(containerWidth)) x \(Int(containerHeight))", systemImage: "ruler")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Text("已缩放到: \(String(format: "%.1f", scale))x")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            } else {
                // 原始尺寸，无缩放
                Label("\(Int(containerWidth)) x \(Int(containerHeight))", systemImage: "ruler")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.horizontal)
        .infinite()
        .background(Color.primary.opacity(0.08))
    }
}
