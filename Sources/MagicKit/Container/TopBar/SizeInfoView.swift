import SwiftUI

/// 尺寸信息显示组件
struct SizeInfoView: View {
    let containerSize: CGSize
    let scale: CGFloat
    
    var body: some View {
        VStack(spacing: 4) {
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

            Label("请按原始尺寸设计你的视图；截图不支持 ScrollView、TabView", systemImage: "info")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
        .background(Color.primary.opacity(0.03))
    }
}

// MARK: - Preview

#if DEBUG
#Preview("iPhone") {
    MagicContainerPreview.iPhonePreview
}
#endif
