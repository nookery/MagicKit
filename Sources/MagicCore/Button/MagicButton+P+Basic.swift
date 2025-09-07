import SwiftUI

#if DEBUG
struct BasicButtonsPreview: View {
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("基础按钮")
                .font(.headline)

            VStack(spacing: 4) {
                MagicButton(icon: "star")
                    .magicTitle("默认按钮")
                Text("系统默认样式")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 4) {
                MagicButton(icon: "star")
                    .magicTitle("默认按钮")
                Text("系统默认样式（示例2）")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 4) {
                MagicButton(icon: "heart")
                    .magicTitle("主要按钮")
                    .magicStyle(.primary)
                Text("强调主要操作")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 4) {
                MagicButton(icon: "trash")
                    .magicTitle("次要按钮")
                    .magicStyle(.secondary)
                Text("一般次要操作")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 4) {
                MagicButton(icon: "checkmark.circle.fill")
                    .magicTitle("成功")
                    .magicStyle(.success)
                Text("表示成功或完成状态")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 4) {
                MagicButton(icon: "exclamationmark.triangle.fill")
                    .magicTitle("警告")
                    .magicStyle(.warning)
                Text("提示风险或需要注意")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 4) {
                MagicButton(icon: "xmark.octagon.fill")
                    .magicTitle("危险")
                    .magicStyle(.danger)
                Text("破坏性或不可逆操作")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 4) {
                MagicButton(icon: "info.circle.fill")
                    .magicTitle("信息")
                    .magicStyle(.info)
                Text("信息性提示")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 4) {
                MagicButton(icon: "ellipsis.circle")
                    .magicTitle("中性")
                    .magicStyle(.neutral)
                Text("低强调或中性操作")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // 测试加载状态的按钮
            MagicButton(
                icon: "arrow.clockwise",
                title: "Test Loading",
                style: .primary,
                loadingStyle: .spinner
            ) { completion in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    completion()
                }
            }
        }
        .padding()
    }
}

#Preview("Basic") {
    BasicButtonsPreview()
}
#endif
