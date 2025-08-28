import SwiftUI

/// 展示 MagicButton 的 id 参数和修改器功能的预览
struct MagicButtonIdPreview: View {
    @State private var buttonId = "initial-id"
    @State private var showIdInfo = false
    @State private var counter = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("MagicButton ID 功能演示")
                .font(.title)
                .padding()
            
            // 显示当前按钮 ID 和计数器
            VStack(spacing: 10) {
                Text("当前按钮 ID:")
                    .font(.headline)
                Text(buttonId)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                Text("点击计数器: \(counter)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // 带 ID 的按钮 - 当 ID 改变时会重新绘制
            MagicButton(
                id: buttonId,
                icon: "star.fill",
                title: "带 ID 的按钮"
            ) { completion in
                counter += 1
                showIdInfo = true
                completion()
            }
            .magicStyle(.primary)
            .magicSize(.large)
            
            // 动态修改 ID 的按钮 - 演示 ID 变化导致视图重新绘制
            MagicButton(
                icon: "pencil",
                title: "修改按钮 ID (会重新绘制)"
            ) { completion in
                buttonId = "button-\(Int.random(in: 1000...9999))"
                counter += 1
                completion()
            }
            .magicStyle(.secondary)
            .magicSize(.regular)
            
            // 使用修改器设置 ID 的按钮
            MagicButton(
                icon: "gear",
                title: "使用修改器设置 ID"
            ) { completion in
                showIdInfo = true
                completion()
            }
            .magicId("modified-id")
            .magicStyle(.custom(.orange))
            .magicSize(.regular)
            
            // 无 ID 的按钮 - 每次都会重新绘制
            MagicButton(
                icon: "questionmark.circle",
                title: "无 ID 按钮 (每次重新绘制)"
            ) { completion in
                counter += 1
                showIdInfo = true
                completion()
            }
            .magicStyle(.secondary)
            .magicSize(.small)
            
            // 演示 ID 对视图重新绘制的影响
            VStack(spacing: 10) {
                Text("ID 的作用说明:")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("• 当 ID 改变时，SwiftUI 会重新创建和绘制按钮")
                    Text("• 这可以用于强制刷新按钮状态或样式")
                    Text("• 无 ID 的按钮每次父视图更新时都会重新绘制")
                    Text("• 有固定 ID 的按钮只在 ID 改变时重新绘制")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding()
        .alert("按钮信息", isPresented: $showIdInfo) {
            Button("确定") { }
        } message: {
            Text("按钮 ID: \(buttonId)\n点击次数: \(counter)")
        }
    }
}

#Preview("ID Preview") {
    MagicButtonIdPreview()
        .inMagicContainer()
}
