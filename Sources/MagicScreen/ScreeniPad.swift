import SwiftUI

public struct iPadDevice: ScreenDevice {
    public var horizon: Bool = false
    
    public init(horizon: Bool = false) {
        self.horizon = horizon
    }
    
    public var screenWidth: CGFloat {
        horizon ? 2275 : 1488
    }
    
    public var screenHeight: CGFloat {
        horizon ? 1500 : 2266
    }
    
    public var deviceImageName: String {
        "iPad mini - Starlight - Portrait"
    }
    
    public var landscapeImageName: String {
        "iPad mini - Starlight - Landscape"
    }
}

public struct ScreeniPad<Content>: View where Content: View {
    private let content: Content
    public var horizon = false

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        ScreenBase(device: iPadDevice(horizon: horizon)) {
            content
        }
    }
}
