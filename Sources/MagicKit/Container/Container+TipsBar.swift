import SwiftUI

extension MagicContainer {
    var tipsBar: some View {
        Label("请按原始尺寸设计你的视图；截图不支持 ScrollView、TabView", systemImage: "info")
            .font(.footnote)
            .foregroundStyle(.secondary)
    }
}
