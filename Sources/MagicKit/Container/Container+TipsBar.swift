import SwiftUI

extension MagicContainer {
    /// 提示栏组件
    struct TipsBar: View {
        var body: some View {
            Label("请按原始尺寸设计你的视图；截图不支持 ScrollView、TabView", systemImage: "info")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
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
