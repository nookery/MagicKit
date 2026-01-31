import SwiftUI

/// Xcode 图标集生成按钮组件
struct XcodeIconButton: View {
    let action: () -> Void
    let containerSize: CGSize

    var body: some View {
        if containerSize.isSquare {
            Button(action: action) {
                HStack {
                    Image(systemName: "hammer")
                    Text("Xcode 图标")
                }
                .padding(.vertical, 4)
            }
            .buttonStyle(.bordered)
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
