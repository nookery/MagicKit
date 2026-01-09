import MagicUI
import SwiftUI

extension AvatarView {
    /// 错误指示视图组件
    struct ErrorIndicatorView: View {
        let error: Error
        @State private var showError = false
        @State private var copied = false

        var body: some View {
            Image.warning
                .foregroundStyle(.red)
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

#Preview {
    AvatarView
        .ErrorIndicatorView(error: URLError(.badURL))
        .frame(width: 100, height: 100)
}
