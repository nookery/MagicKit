import SwiftUI

/// 尺寸信息显示组件
struct SizeInfoView: View {
    let containerSize: CGSize
    let scale: CGFloat

    var body: some View {
        HStack {
            Spacer()
            if scale != 1.0 {
                // 显示缩放后的实际尺寸和缩放比例
                Label("原始尺寸: \(Int(containerSize.width)) x \(Int(containerSize.height))", systemImage: "ruler")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Text("已缩放到: \(String(format: "%.1f", scale))x")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            } else {
                // 原始尺寸，无缩放
                Label("\(Int(containerSize.width)) x \(Int(containerSize.height))", systemImage: "ruler")
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

#if DEBUG
    import SwiftUI

    #Preview("iMac 27 - 缩放") {
        Text("Hello, World!")
            .font(.system(size: 400))
            .magicCentered()
            .background(.indigo.opacity(0.3))
            .inMagicContainer(.iMac27, scale: 0.1)
    }
#endif
