import SwiftUI

public struct iMacDevice: ScreenDevice {
    public var horizon: Bool = false
    
    public init(horizon: Bool = false) {
        self.horizon = horizon
    }
    
    public var screenWidth: CGFloat {
        horizon ? 2275 : 5120
    }
    
    public var screenHeight: CGFloat {
        horizon ? 1500 : 2890
    }
    
    public var deviceImageName: String {
        "iMac 27\" - Silver"
    }
    
    public var landscapeImageName: String {
        "iPad mini - Starlight - Landscape"
    }
}

public struct ScreeniMac<Content>: View where Content: View {
    private let content: Content
    public var horizon = false

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        ScreenBase(device: iMacDevice(horizon: horizon)) {
            content
        }
    }
}
