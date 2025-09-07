import SwiftUI

/// 智能缩放视图，根据内容尺寸和容器尺寸自动决定是否缩放
/// 如果内容比容器小很多，则不缩放；如果内容比容器大很多，则按比例缩放
struct SmartScaleView<Content: View>: View {
    private let content: Content
    private let containerWidth: CGFloat
    private let containerHeight: CGFloat
    private let minScaleThreshold: CGFloat
    private let maxScaleThreshold: CGFloat
    
    @State private var contentSize: CGSize = .zero
    
    /// 创建智能缩放视图
    /// - Parameters:
    ///   - content: 要显示的内容视图
    ///   - containerWidth: 目标容器宽度
    ///   - containerHeight: 目标容器高度
    ///   - minScaleThreshold: 最小缩放阈值，内容小于容器的此比例时不缩放（默认 0.8）
    ///   - maxScaleThreshold: 最大缩放阈值，内容大于容器的此比例时开始缩放（默认 1.2）
    init(
        content: Content,
        containerWidth: CGFloat,
        containerHeight: CGFloat,
        minScaleThreshold: CGFloat = 0.8,
        maxScaleThreshold: CGFloat = 1.2
    ) {
        self.content = content
        self.containerWidth = containerWidth
        self.containerHeight = containerHeight
        self.minScaleThreshold = minScaleThreshold
        self.maxScaleThreshold = maxScaleThreshold
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 信息栏
            infoBar
            
            // 缩放后的内容视图
            content
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                contentSize = geometry.size
                            }
                            .onChange(of: geometry.size) { _, newSize in
                                contentSize = newSize
                            }
                    }
                )
                .scaleEffect(scaleAmount)
                .animation(.easeInOut(duration: 0.3), value: scaleAmount)
                .frame(width: containerWidth, height: containerHeight)
                .dashedBorder(color: .blue, lineWidth: 1, dash: [8, 4])
        }
    }
}

// MARK: - Private Helpers
extension SmartScaleView {
    /// 信息栏视图
    private var infoBar: some View {
        HStack(spacing: 20) {
            Spacer()
            // 原视图大小
            VStack(alignment: .leading, spacing: 4) {
                Text("原视图大小")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(Int(contentSize.width)) × \(Int(contentSize.height))")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            
            Divider()
                .frame(height: 30)
            
            // 容器大小
            VStack(alignment: .leading, spacing: 4) {
                Text("容器大小")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(Int(containerWidth)) × \(Int(containerHeight))")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            
            Divider()
                .frame(height: 30)
            
            // 缩放比例
            VStack(alignment: .leading, spacing: 4) {
                Text("缩放比例")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(String(format: "%.2f×", scaleAmount))
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(scaleAmount == 1.0 ? .green : .orange)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.background)
    }
    
    /// 计算智能缩放比例
    private var scaleAmount: CGFloat {
        guard contentSize.width > 0, contentSize.height > 0 else { return 1.0 }
        
        // 计算内容的宽高比和容器的宽高比
        let contentAspectRatio = contentSize.width / contentSize.height
        let containerAspectRatio = containerWidth / containerHeight
        
        // 根据宽高比决定使用哪个维度作为缩放基准
        let scaleFactor: CGFloat
        if contentAspectRatio > containerAspectRatio {
            // 内容更宽，以宽度为基准
            scaleFactor = containerWidth / contentSize.width
        } else {
            // 内容更高，以高度为基准
            scaleFactor = containerHeight / contentSize.height
        }
        
        // 智能缩放逻辑
        if scaleFactor >= maxScaleThreshold {
            // 内容比容器小很多，不放大
            return 1.0
        } else if scaleFactor <= minScaleThreshold {
            // 内容比容器大很多，按比例缩小
            return scaleFactor
        } else {
            // 内容尺寸适中，不缩放
            return 1.0
        }
    }
}

// MARK: - Preview
#Preview("SmartScaleView - Large Content") {
    SmartScaleView(
        content: Rectangle()
            .fill(Color.blue)
            .frame(width: 800, height: 600),
        containerWidth: 400,
        containerHeight: 300
    )
}

#Preview("SmartScaleView - Small Content") {
    SmartScaleView(
        content: Rectangle()
            .fill(Color.green)
            .frame(width: 200, height: 150),
        containerWidth: 400,
        containerHeight: 300
    )
}

#Preview("SmartScaleView - Perfect Fit") {
    SmartScaleView(
        content: Rectangle()
            .fill(Color.orange)
            .frame(width: 380, height: 280),
        containerWidth: 400,
        containerHeight: 300
    )
}

#Preview("SmartScaleView - Complex Content") {
    SmartScaleView(
        content: VStack(spacing: 20) {
            Text("这是一个很长的标题，用来测试智能缩放功能")
                .font(.title)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 10) {
                ForEach(0..<5) { index in
                    Circle()
                        .fill(Color.purple)
                        .frame(width: 50, height: 50)
                }
            }
            
            Text("内容描述")
                .font(.body)
        }
        .padding()
        .background(Color.yellow.opacity(0.3))
        .frame(width: 600, height: 400),
        containerWidth: 300,
        containerHeight: 200
    )
}

#Preview("SmartScaleView - iPhone Size") {
    SmartScaleView(
        content: VStack {
            Image(systemName: "iphone")
                .font(.system(size: 100))
                .foregroundColor(.blue)
            
            Text("iPhone 预览")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("这是一个iPhone尺寸的预览")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(40)
        .background(.background)
        .cornerRadius(20)
        .frame(width: 375, height: 812),
        containerWidth: 200,
        containerHeight: 400
    )
}
