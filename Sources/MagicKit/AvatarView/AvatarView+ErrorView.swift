import MagicUI
import SwiftUI

extension AvatarView {
    /// 错误指示视图组件
    struct ErrorView: View {
        let error: Error
        let shape: AvatarViewShape
        let size: CGSize
        let backgroundColor: Color
        @State private var showError = false
        @State private var copied = false
        @State private var isHovered = false

        var body: some View {
            Image.warning
                .foregroundStyle(.red.opacity(isHovered ? 0.7 : 1.0))
                .frame(width: size.width, height: size.height)
                .background(backgroundColor)
                .clipShape(shape)
                .overlay {
                    shape.strokeBorder(color: Color.red.opacity(0.5))
                }
                .onHover { hovering in
                    isHovered = hovering
                }
                .popover(isPresented: $showError) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("错误详情")
                            .font(.headline)

                        Divider()

                        Text(error.localizedDescription)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)

                        Divider()

                        Button(action: {
                            error.copy()
                            copied = true

                            // 2秒后重置复制状态
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                copied = false
                            }
                        }) {
                            HStack {
                                Image(systemName: copied ? .iconCheckmark : .iconCopy)
                                Text(copied ? "已复制" : "复制错误信息")
                            }
                            .foregroundStyle(copied ? .green : .accentColor)
                        }
                        .buttonStyle(.borderless)
                    }
                    .padding()
                    .frame(minWidth: 200, maxWidth: 300)
                }
                .onTapGesture {
                    showError = true
                }
        }
    }
}

#if DEBUG
    #Preview("文件类型") {
        AvatarFileTypesPreview()
            .frame(width: 500, height: 500)
    }

    #Preview {
        AvatarView
            .ErrorView(
                error: URLError(.badURL),
                shape: .circle,
                size: CGSize(width: 100, height: 100),
                backgroundColor: .blue.opacity(0.1)
            )
            .magicCentered()
    }
#endif
