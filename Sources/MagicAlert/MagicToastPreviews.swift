import SwiftUI

#if DEBUG
    struct MagicToastExampleView: View {
        private var messageProvider = MagicMessageProvider.shared

        var body: some View {
            VStack(spacing: 20) {
                Text("Magic Toast 示例")
                    .font(.title)

                Button("信息") {
                    messageProvider.info("这是信息", subtitle: "详细描述")
                }

                Button("信息 - 长文字") {
                    messageProvider.info("开始下载你选择的文档")
                }

                Button("成功") {
                    messageProvider.success("操作成功")
                }

                Button("警告") {
                    messageProvider.warning("注意事项")
                }

                Button("错误") {
                    messageProvider.error("操作失败", autoDismiss: false)
                }
                
                Button("错误 - 详细视图") {
                    // 创建一个模拟的复杂错误来展示新功能
                    let customError = NSError(
                        domain: "com.magickit.test",
                        code: 1001,
                        userInfo: [
                            NSLocalizedDescriptionKey: "网络连接失败，无法访问服务器端点",
                            NSLocalizedFailureReasonErrorKey: "服务器响应超时，可能是网络不稳定、服务器维护或防火墙阻拦",
                            NSLocalizedRecoverySuggestionErrorKey: "请检查网络连接状态，确认VPN设置，稍后重试。如果问题持续存在，请联系技术支持团队。",
                            NSHelpAnchorErrorKey: "访问帮助中心获取更多网络故障排除信息和常见问题解答"
                        ]
                    )
                    messageProvider.error(customError, title: "网络请求失败")
                }

                Button("加载中") {
                    messageProvider.loading("正在处理...")
                }

                Button("隐藏加载") {
                    messageProvider.hideLoading()
                }
            }
            .buttonStyle(.bordered)
            .padding()
        }
    }
#endif

#if DEBUG
#Preview("正常宽度") {
    MagicToastExampleView()
        .withMagicToast()
        .frame(width: 600, height: 600)
}

#Preview("窄屏宽度") {
    MagicToastExampleView()
        .withMagicToast()
        .frame(width: 320, height: 600)
}

#Preview("iPad宽度") {
    MagicToastExampleView()
        .withMagicToast()
        .frame(width: 800, height: 600)
}
#endif
