import SwiftUI
import MagicDevice

/// MagicContainer 预览视图
struct MagicContainerPreview: View {
    var body: some View {
        // 默认显示 iPhone 预览
        MagicContainerPreview.iPhonePreview
    }
}

// MARK: - Preview Variants

extension MagicContainerPreview {
    /// iPhone 预览
    static var iPhonePreview: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Hello, World!")
                    .padding()
                Spacer()
            }
            Spacer()
        }
        .background(.orange.opacity(0.3))
        .inMagicContainer(.iPhone)
    }
    
    /// iPhone SE 预览
    static var iPhoneSEPreview: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Hello, World!")
                    .padding()
                Spacer()
            }
            Spacer()
        }
        .background(.red.opacity(0.3))
        .inMagicContainer(.iPhoneSE)
    }
    
    /// MacBook 13 - 100% 预览
    static var macBook13FullPreview: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Hello, World!")
                    .font(.system(size: 400))
                    .padding()
                Spacer()
            }
            Spacer()
        }
        .background(.indigo.opacity(0.3))
        .inMagicContainer(.macBook13, scale: 0.2)
    }
    
    /// MacBook 13 - 20% 预览
    static var macBook13TwentyPercentPreview: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Hello, World!")
                    .font(.system(size: 40))
                    .padding()
                Spacer()
            }
            Spacer()
        }
        .background(.indigo.opacity(0.3))
        .inMagicContainer(.macBook13_20Percent)
    }
    
    /// MacBook 13 - 10% 预览
    static var macBook13TenPercentPreview: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Hello, World!")
                    .font(.system(size: 20))
                    .padding()
                Spacer()
            }
            Spacer()
        }
        .background(.indigo.opacity(0.3))
        .inMagicContainer(.macBook13_10Percent)
    }
    
    /// iMac 27 - 100% 预览
    static var iMac27FullPreview: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Hello, World!")
                    .font(.system(size: 400))
                    .padding()
                Spacer()
            }
            Spacer()
        }
        .background(.indigo.opacity(0.3))
        .inMagicContainer(.iMac27)
    }
    
    /// iMac 27 - 20% 预览
    static var iMac27TwentyPercentPreview: some View {
        Text("Hello, World!")
            .padding()
            .inMagicContainer(.iMac27_20Percent)
    }
    
    /// iMac 27 - 10% 预览
    static var iMac27TenPercentPreview: some View {
        Text("Hello, World!")
            .padding()
            .inMagicContainer(.iMac27_10Percent)
    }
    
    /// iMac 27 - 缩放示例预览
    static var iMac27ScalePreview: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Hello, World!")
                    .font(.system(size: 400))
                    .padding()
                Spacer()
            }
            Spacer()
        }
        .background(.indigo.opacity(0.3))
        .inMagicContainer(.iMac27, scale: 0.1)
    }
    
    /// MacBook 13 - 缩放示例预览
    static var macBook13ScalePreview: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Hello, World!")
                    .font(.system(size: 200))
                    .padding()
                Spacer()
            }
            Spacer()
        }
        .background(.green.opacity(0.3))
        .inMagicContainer(.macBook13, scale: 0.3)
    }
}

// MARK: - Preview

#if DEBUG
#Preview("iPhone") {
    MagicContainerPreview.iPhonePreview
}

#Preview("iPhoneSE") {
    MagicContainerPreview.iPhoneSEPreview
}

#Preview("MacBook 13 - 100%") {
    MagicContainerPreview.macBook13FullPreview
}

#Preview("MacBook 13 - 20%") {
    MagicContainerPreview.macBook13TwentyPercentPreview
}

#Preview("MacBook 13 - 10%") {
    MagicContainerPreview.macBook13TenPercentPreview
}

#Preview("iMac 27 - 100%") {
    MagicContainerPreview.iMac27FullPreview
}

#Preview("iMac 27 - 20%") {
    MagicContainerPreview.iMac27TwentyPercentPreview
}

#Preview("iMac 27 - 10%") {
    MagicContainerPreview.iMac27TenPercentPreview
}

#Preview("iMac 27 - 缩放示例") {
    MagicContainerPreview.iMac27ScalePreview
}

#Preview("MacBook 13 - 缩放示例") {
    MagicContainerPreview.macBook13ScalePreview
}

// MARK: - App Preview

#Preview("App - Large") {
    MagicContainerPreview.iPhonePreview
        .frame(width: 600, height: 1000)
}

#Preview("App - Small") {
    MagicContainerPreview.iPhoneSEPreview
        .frame(width: 600, height: 600)
}
#endif
