import SwiftUI
import MagicCore

public protocol ScreenDevice {
    var screenWidth: CGFloat { get }
    var screenHeight: CGFloat { get }
    var deviceImageName: String { get }
    var landscapeImageName: String { get }
}

public struct ScreenBase<Content>: View where Content: View {
    private let content: Content
    private let device: ScreenDevice
    public var horizon = false

    public init(device: ScreenDevice, @ViewBuilder content: () -> Content) {
        self.device = device
        self.content = content()
    }

    public var body: some View {
        GeometryReader { geo in
            ZStack {
                fullView
            }
            .scaleEffect(getScale(geo), anchor: .topLeading)
            .offset(x: getOffsetX(geo), y: getOffsetY(geo))
        }
    }

    @MainActor var fullView: some View {
        ZStack {
            content
                .frame(width: device.screenWidth, height: device.screenHeight)

            getDeviceImage()
        }
        .frame(width: getDeviceWidth())
        .frame(height: getDeviceHeight())
    }

    private func getDeviceImage() -> Image {
        return Image(horizon ? device.landscapeImageName : device.deviceImageName, bundle: Bundle.module)
    }
    
    // MARK: X的偏移量，用于居中
    
    @MainActor func getOffsetX(_ geo: GeometryProxy) -> CGFloat {
        if getScale(geo) == geo.size.width/getDeviceWidth() {
            return 0
        }
        
        return (geo.size.width-getScale(geo)*getDeviceWidth())*0.5
    }
    
    // MARK: Y的偏移量，用于居中
    
    @MainActor func getOffsetY(_ geo: GeometryProxy) -> CGFloat {
        if getScale(geo) == geo.size.height/getDeviceHeight() {
            return 0
        }
        
        return (geo.size.width-getScale(geo)*getDeviceHeight())*0.5
    }
    
    // MARK: 缩放的比例
    
    @MainActor func getScale(_ geo: GeometryProxy) -> CGFloat {
        min(geo.size.width / getDeviceWidth(), geo.size.height / getDeviceHeight())
    }
    
    // MARK: 设备图片的高度

    @MainActor private func getDeviceHeight() -> CGFloat {
        CGFloat(MagicImage.getViewHeight(getDeviceImage()))
    }

    // MARK: 设备图片的宽度

    @MainActor private func getDeviceWidth() -> CGFloat {
        CGFloat(MagicImage.getViewWidth(getDeviceImage()))
    }

    // MARK: 设备图片的尺寸

    @MainActor private func getDeviceSize() -> String {
        let deviceImage = getDeviceImage()
        return "\(MagicImage.getViewWidth(deviceImage)) X \(MagicImage.getViewHeight(deviceImage))"
    }

    // MARK: 设备图片的屏幕尺寸

    @MainActor private func getScreenSize() -> String {
        "\(device.screenWidth) X \(device.screenHeight)"
    }
}
