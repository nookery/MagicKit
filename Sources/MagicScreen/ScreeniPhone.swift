import SwiftUI

public struct iPhoneDevice: ScreenDevice {
    public var horizon: Bool = false
    
    public init(horizon: Bool = false) {
        self.horizon = horizon
    }
    
    public var screenWidth: CGFloat {
        horizon ? 2275 : 1165
    }
    
    public var screenHeight: CGFloat {
        horizon ? 1500 : 2528
    }
    
    public var deviceImageName: String {
        "iPhone 14 - Midnight - Portrait"
    }
    
    public var landscapeImageName: String {
        "iPad mini - Starlight - Landscape"
    }
}

public struct ScreeniPhone<Content>: View where Content: View {
    private let content: Content
    public var horizon = false

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        ScreenBase(device: iPhoneDevice(horizon: horizon)) {
            content
        }
    }
}
