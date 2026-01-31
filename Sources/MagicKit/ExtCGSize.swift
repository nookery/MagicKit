import Foundation

/// CGSize 类型的扩展，提供常用设备尺寸和实用方法
///
/// 这个扩展为CGSize类型添加了常用iOS和macOS设备的物理像素尺寸常量，
/// 以及一些实用的属性，便于在开发中快速引用和判断尺寸特性。
///
/// ## 使用示例:
/// ```swift
/// // 使用预定义的设备尺寸
/// let iPhoneSize = CGSize.iPhone
///
/// // 检查尺寸是否为正方形
/// let isSquare = iPhoneSize.isSquare // false
///
/// // 获取尺寸的字符串描述
/// let sizeDescription = iPhoneSize.description // "1170x2532"
/// ```
public extension CGSize {
    // MARK: - iPhone - Compact

    /// iPhone SE 的物理像素尺寸 (750x1334 像素)，@2x缩放
    static let iPhoneSE = CGSize(width: 750, height: 1334)

    /// iPhone 4.7英寸的物理像素尺寸 (750x1334 像素)，@2x缩放，适用于iPhone 6/7/8等
    static let iPhone47 = CGSize(width: 750, height: 1334)

    /// iPhone 5.4英寸mini的物理像素尺寸 (1080x2340 像素)，@3x缩放，适用于iPhone 12/13/14 mini等
    static let iPhoneMini = CGSize(width: 1080, height: 2340)

    // MARK: - iPhone - Standard

    /// iPhone 5.8英寸的物理像素尺寸 (1125x2436 像素)，@3x缩放，适用于iPhone X/XS/11 Pro等
    static let iPhone58 = CGSize(width: 1125, height: 2436)

    /// iPhone 6.1英寸LCD的物理像素尺寸 (828x1792 像素)，@2x缩放，适用于iPhone XR/11等
    static let iPhone61LCD = CGSize(width: 828, height: 1792)

    /// 标准iPhone的物理像素尺寸 (1170x2532 像素)，@3x缩放，适用于iPhone 12/13/14等
    static let iPhone = CGSize(width: 1170, height: 2532)

    /// iPhone 6.1英寸OLED的物理像素尺寸 (1179x2556 像素)，@3x缩放，适用于iPhone 12/13/14 Pro等
    static let iPhonePro = CGSize(width: 1179, height: 2556)

    // MARK: - iPhone - Large

    /// iPhone 5.5英寸 Plus的物理像素尺寸 (1242x2208 像素)，@3x缩放，适用于iPhone 6/7/8 Plus等
    static let iPhone55 = CGSize(width: 1242, height: 2208)

    /// 6.5英寸iPhone的物理像素尺寸 (1242x2688 像素)，@3x缩放，适用于iPhone XS Max、11 Pro Max等
    static let iPhone65 = CGSize(width: 1242, height: 2688)

    /// 大尺寸iPhone Plus的物理像素尺寸 (1284x2778 像素)，@3x缩放，适用于iPhone Plus系列
    static let iPhonePlus = CGSize(width: 1284, height: 2778)

    /// 6.9英寸iPhone的物理像素尺寸 (1290x2796 像素)，@3x缩放，适用于iPhone 14 Pro Max、15 Pro Max等
    static let iPhone69 = CGSize(width: 1290, height: 2796)

    /// 最大尺寸iPhone的物理像素尺寸 (1290x2796 像素)，@3x缩放，适用于iPhone Pro Max系列
    static let iPhoneMax = CGSize(width: 1290, height: 2796)

    // MARK: - iPad

    /// iPad Mini的物理像素尺寸 (1488x2266 像素)，@2x缩放
    static let iPadMini = CGSize(width: 1488, height: 2266)

    /// 标准iPad的物理像素尺寸 (1640x2360 像素)，@2x缩放
    static let iPad = CGSize(width: 1640, height: 2360)

    /// iPad Pro 11英寸的物理像素尺寸 (1668x2388 像素)，@2x缩放
    static let iPadPro11 = CGSize(width: 1668, height: 2388)

    /// iPad Pro 12.9英寸的物理像素尺寸 (2048x2732 像素)，@2x缩放
    static let iPadPro12 = CGSize(width: 2048, height: 2732)
    /// 标准Mac窗口的参考尺寸 (1024x768 像素)
    static let mac = CGSize(width: 1024, height: 768)

    // MARK: - MacBook

    /// MacBook Air 13英寸屏幕物理像素尺寸 (2560x1600 像素)，@2x Retina缩放
    static let macBookAir13 = CGSize(width: 2560, height: 1600)

    /// MacBook Pro 13英寸屏幕物理像素尺寸 (2560x1600 像素)，@2x Retina缩放
    static let macBookPro13 = CGSize(width: 2560, height: 1600)

    /// MacBook Pro 14英寸屏幕物理像素尺寸 (3024x1964 像素)，@2x Retina缩放
    static let macBookPro14 = CGSize(width: 3024, height: 1964)

    /// MacBook Pro 16英寸屏幕物理像素尺寸 (3456x2234 像素)，@2x Retina缩放
    static let macBookPro16 = CGSize(width: 3456, height: 2234)

    // MARK: - Legacy

    /// MacBook 13英寸屏幕物理像素尺寸 (2560x1600 像素)，@2x Retina缩放（已废弃，请使用macBookPro13）
    static let macBook13 = CGSize(width: 2560, height: 1600)

    /// MacBook 13英寸屏幕的20%缩放尺寸 (512x320 像素)
    static let macBook13_20Percent = CGSize(width: 512, height: 320)

    /// MacBook 13英寸屏幕的10%缩放尺寸 (256x160 像素)
    static let macBook13_10Percent = CGSize(width: 256, height: 160)

    // MARK: - iMac

    /// iMac 24英寸M1/M3/M4屏幕物理像素尺寸 (4480x2520 像素)，@2x Retina缩放
    static let iMac24 = CGSize(width: 4480, height: 2520)

    /// iMac 27英寸Retina屏幕物理像素尺寸 (5120x2880 像素)，@2x Retina缩放
    static let iMac27 = CGSize(width: 5120, height: 2880)

    /// iMac 27英寸屏幕的20%缩放尺寸 (1024x576 像素)
    static let iMac27_20Percent = CGSize(width: 1024, height: 576)

    /// iMac 27英寸屏幕的10%缩放尺寸 (512x288 像素)
    static let iMac27_10Percent = CGSize(width: 512, height: 288)

    // MARK: - External Displays

    /// Apple Studio Display 27英寸屏幕物理像素尺寸 (5120x2880 像素)，@2x Retina缩放
    static let studioDisplay = CGSize(width: 5120, height: 2880)

    /// Apple Pro Display XDR 32英寸屏幕物理像素尺寸 (6016x3384 像素)，@2x Retina缩放
    static let proDisplayXDR = CGSize(width: 6016, height: 3384)

    /// 判断尺寸是否为正方形
    ///
    /// 当宽度等于高度时返回true，否则返回false
    var isSquare: Bool {
        width == height
    }

    /// 获取尺寸的字符串描述
    ///
    /// 返回格式为"宽度x高度"的字符串，例如"1170x2532"
    var description: String {
        "\(width)x\(height)"
    }

    /// 判断宽度是否小于高度
    ///
    /// 当宽度小于高度时返回true，常用于判断是否为纵向布局
    var isWidthLessThanHeight: Bool {
        width < height
    }

    /// 判断宽度是否大于高度
    ///
    /// 当宽度大于高度时返回true，常用于判断是否为横向布局
    var isWidthGreaterThanHeight: Bool {
        width > height
    }
}
