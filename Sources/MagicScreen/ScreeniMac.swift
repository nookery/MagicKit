import SwiftUI

public struct iMacDevice: SuperScreen {
    public var screenWidth: CGFloat {
        5120
    }
    
    public var screenHeight: CGFloat {
        2890
    }
    
    public var deviceImageName: String {
        "iMac 27\" - Silver"
    }
    
    public var landscapeImageName: String? {
        nil
    }
    
    public var screenOffsetX: CGFloat {
        0
    }
    
    public var screenOffsetY: CGFloat {
        -568
    }
}

public struct ScreeniMac<Content>: View where Content: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        ScreenBase(device: iMacDevice(), horizon: false) {
            content
        }
    }
}

// MARK: - View Extensions

public extension View {
    /// 将当前视图包装在 iMac 屏幕中
    /// - Returns: 包装在 iMac 屏幕中的视图
    func inIMacScreen() -> some View {
        ScreeniMac {
            self
        }
    }
}

// MARK: - Preview

#Preview("iMac - Basic") {
    HStack {
        Spacer()
        VStack {
            Spacer()
            Image(systemName: "desktopcomputer")
                .font(.system(size: 400))
                .foregroundColor(.blue)
            
            Text("iMac 预览")
                .font(.system(size: 300))
                .fontWeight(.bold)
            Spacer()
        }
        Spacer()
    }
    .padding(40)
    .background(.orange.opacity(0.2))
    .inIMacScreen()
}

#Preview("iMac - Custom View") {
    HStack {
        Spacer()
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "star.fill")
                .font(.system(size: 400))
                .foregroundColor(.yellow)
            
            Text("自定义视图")
                .font(.system(size: 400))
                .fontWeight(.semibold)
            Spacer()
        }
        Spacer()
    }
    .padding(30)
    .background(.blue.opacity(0.1))
    .inIMacScreen()
}
