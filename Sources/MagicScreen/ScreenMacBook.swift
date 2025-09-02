import SwiftUI

public struct MacBookDevice: ScreenDevice {
    public var horizon: Bool = false
    
    public init(horizon: Bool = false) {
        self.horizon = horizon
    }
    
    public var screenWidth: CGFloat {
        horizon ? 2275 : 2550
    }
    
    public var screenHeight: CGFloat {
        horizon ? 1500 : 1650
    }
    
    public var deviceImageName: String {
        "MacBook Air 13\" - 4th Gen - Midnight"
    }
    
    public var landscapeImageName: String {
        "iPad mini - Starlight - Landscape"
    }
}

public struct ScreenMacBook<Content>: View where Content: View {
    private let content: Content
    public var horizon = false

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        ScreenBase(device: MacBookDevice(horizon: horizon)) {
            content
        }
    }
}
