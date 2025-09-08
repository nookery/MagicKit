import Foundation
import SwiftUI

/// CGSize 类型的扩展，提供常用设备尺寸和实用方法
///
/// 这个扩展为CGSize类型添加了常用iOS和macOS设备的标准尺寸常量，
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
/// let sizeDescription = iPhoneSize.description // "390x844"
/// ```
public extension CGSize {
    /// iPhone SE 的标准屏幕尺寸 (375x667 点) - 1.0x 缩放
    static let iPhoneSE = CGSize(width: 375, height: 667)
    /// iPhone SE 预览尺寸 (338x600 点) - 0.9x 缩放
    static let iPhoneSE_90Percent = CGSize(width: 338, height: 600)
    /// iPhone SE 预览尺寸 (300x534 点) - 0.8x 缩放
    static let iPhoneSE_80Percent = CGSize(width: 300, height: 534)
    /// iPhone SE 预览尺寸 (263x467 点) - 0.7x 缩放
    static let iPhoneSE_70Percent = CGSize(width: 263, height: 467)
    /// iPhone SE 预览尺寸 (225x400 点) - 0.6x 缩放
    static let iPhoneSE_60Percent = CGSize(width: 225, height: 400)
    /// iPhone SE 预览尺寸 (188x334 点) - 0.5x 缩放
    static let iPhoneSE_50Percent = CGSize(width: 188, height: 334)
    /// iPhone SE 预览尺寸 (150x267 点) - 0.4x 缩放
    static let iPhoneSE_40Percent = CGSize(width: 150, height: 267)
    /// iPhone SE 预览尺寸 (113x200 点) - 0.3x 缩放
    static let iPhoneSE_30Percent = CGSize(width: 113, height: 200)
    /// iPhone SE 预览尺寸 (75x134 点) - 0.2x 缩放
    static let iPhoneSE_20Percent = CGSize(width: 75, height: 134)
    /// iPhone SE 预览尺寸 (38x67 点) - 0.1x 缩放
    static let iPhoneSE_10Percent = CGSize(width: 38, height: 67)

    /// 标准iPhone的屏幕尺寸 (390x844 点) - 1.0x 缩放
    static let iPhone = CGSize(width: 390, height: 844)
    /// iPhone 预览尺寸 (351x760 点) - 0.9x 缩放
    static let iPhone_90Percent = CGSize(width: 351, height: 760)
    /// iPhone 预览尺寸 (312x675 点) - 0.8x 缩放
    static let iPhone_80Percent = CGSize(width: 312, height: 675)
    /// iPhone 预览尺寸 (273x591 点) - 0.7x 缩放
    static let iPhone_70Percent = CGSize(width: 273, height: 591)
    /// iPhone 预览尺寸 (234x506 点) - 0.6x 缩放
    static let iPhone_60Percent = CGSize(width: 234, height: 506)
    /// iPhone 预览尺寸 (195x422 点) - 0.5x 缩放
    static let iPhone_50Percent = CGSize(width: 195, height: 422)
    /// iPhone 预览尺寸 (156x338 点) - 0.4x 缩放
    static let iPhone_40Percent = CGSize(width: 156, height: 338)
    /// iPhone 预览尺寸 (117x253 点) - 0.3x 缩放
    static let iPhone_30Percent = CGSize(width: 117, height: 253)
    /// iPhone 预览尺寸 (78x169 点) - 0.2x 缩放
    static let iPhone_20Percent = CGSize(width: 78, height: 169)
    /// iPhone 预览尺寸 (39x84 点) - 0.1x 缩放
    static let iPhone_10Percent = CGSize(width: 39, height: 84)
    
    /// 大尺寸iPhone Plus的屏幕尺寸 (428x926 点) - 1.0x 缩放
    static let iPhonePlus = CGSize(width: 428, height: 926)
    /// iPhone Plus 预览尺寸 (385x833 点) - 0.9x 缩放
    static let iPhonePlus_90Percent = CGSize(width: 385, height: 833)
    /// iPhone Plus 预览尺寸 (342x741 点) - 0.8x 缩放
    static let iPhonePlus_80Percent = CGSize(width: 342, height: 741)
    /// iPhone Plus 预览尺寸 (300x648 点) - 0.7x 缩放
    static let iPhonePlus_70Percent = CGSize(width: 300, height: 648)
    /// iPhone Plus 预览尺寸 (257x556 点) - 0.6x 缩放
    static let iPhonePlus_60Percent = CGSize(width: 257, height: 556)
    /// iPhone Plus 预览尺寸 (214x463 点) - 0.5x 缩放
    static let iPhonePlus_50Percent = CGSize(width: 214, height: 463)
    /// iPhone Plus 预览尺寸 (171x370 点) - 0.4x 缩放
    static let iPhonePlus_40Percent = CGSize(width: 171, height: 370)
    /// iPhone Plus 预览尺寸 (128x278 点) - 0.3x 缩放
    static let iPhonePlus_30Percent = CGSize(width: 128, height: 278)
    /// iPhone Plus 预览尺寸 (86x185 点) - 0.2x 缩放
    static let iPhonePlus_20Percent = CGSize(width: 86, height: 185)
    /// iPhone Plus 预览尺寸 (43x93 点) - 0.1x 缩放
    static let iPhonePlus_10Percent = CGSize(width: 43, height: 93)

    /// 最大尺寸iPhone的屏幕尺寸 (430x932 点) - 1.0x 缩放
    static let iPhoneMax = CGSize(width: 430, height: 932)
    /// iPhone Max 预览尺寸 (387x839 点) - 0.9x 缩放
    static let iPhoneMax_90Percent = CGSize(width: 387, height: 839)
    /// iPhone Max 预览尺寸 (344x746 点) - 0.8x 缩放
    static let iPhoneMax_80Percent = CGSize(width: 344, height: 746)
    /// iPhone Max 预览尺寸 (301x652 点) - 0.7x 缩放
    static let iPhoneMax_70Percent = CGSize(width: 301, height: 652)
    /// iPhone Max 预览尺寸 (258x559 点) - 0.6x 缩放
    static let iPhoneMax_60Percent = CGSize(width: 258, height: 559)
    /// iPhone Max 预览尺寸 (215x466 点) - 0.5x 缩放
    static let iPhoneMax_50Percent = CGSize(width: 215, height: 466)
    /// iPhone Max 预览尺寸 (172x373 点) - 0.4x 缩放
    static let iPhoneMax_40Percent = CGSize(width: 172, height: 373)
    /// iPhone Max 预览尺寸 (129x279 点) - 0.3x 缩放
    static let iPhoneMax_30Percent = CGSize(width: 129, height: 279)
    /// iPhone Max 预览尺寸 (86x186 点) - 0.2x 缩放
    static let iPhoneMax_20Percent = CGSize(width: 86, height: 186)
    /// iPhone Max 预览尺寸 (43x93 点) - 0.1x 缩放
    static let iPhoneMax_10Percent = CGSize(width: 43, height: 93)

    /// iPad Mini的标准屏幕尺寸 (744x1133 点) - 1.0x 缩放
    static let iPadMini = CGSize(width: 744, height: 1133)
    /// iPad Mini 预览尺寸 (670x1020 点) - 0.9x 缩放
    static let iPadMini_90Percent = CGSize(width: 670, height: 1020)
    /// iPad Mini 预览尺寸 (595x906 点) - 0.8x 缩放
    static let iPadMini_80Percent = CGSize(width: 595, height: 906)
    /// iPad Mini 预览尺寸 (521x793 点) - 0.7x 缩放
    static let iPadMini_70Percent = CGSize(width: 521, height: 793)
    /// iPad Mini 预览尺寸 (446x680 点) - 0.6x 缩放
    static let iPadMini_60Percent = CGSize(width: 446, height: 680)
    /// iPad Mini 预览尺寸 (372x567 点) - 0.5x 缩放
    static let iPadMini_50Percent = CGSize(width: 372, height: 567)
    /// iPad Mini 预览尺寸 (298x453 点) - 0.4x 缩放
    static let iPadMini_40Percent = CGSize(width: 298, height: 453)
    /// iPad Mini 预览尺寸 (223x340 点) - 0.3x 缩放
    static let iPadMini_30Percent = CGSize(width: 223, height: 340)
    /// iPad Mini 预览尺寸 (149x227 点) - 0.2x 缩放
    static let iPadMini_20Percent = CGSize(width: 149, height: 227)
    /// iPad Mini 预览尺寸 (74x113 点) - 0.1x 缩放
    static let iPadMini_10Percent = CGSize(width: 74, height: 113)

    /// 标准iPad的屏幕尺寸 (820x1180 点) - 1.0x 缩放
    static let iPad = CGSize(width: 820, height: 1180)
    /// iPad 预览尺寸 (738x1062 点) - 0.9x 缩放
    static let iPad_90Percent = CGSize(width: 738, height: 1062)
    /// iPad 预览尺寸 (656x944 点) - 0.8x 缩放
    static let iPad_80Percent = CGSize(width: 656, height: 944)
    /// iPad 预览尺寸 (574x826 点) - 0.7x 缩放
    static let iPad_70Percent = CGSize(width: 574, height: 826)
    /// iPad 预览尺寸 (492x708 点) - 0.6x 缩放
    static let iPad_60Percent = CGSize(width: 492, height: 708)
    /// iPad 预览尺寸 (410x590 点) - 0.5x 缩放
    static let iPad_50Percent = CGSize(width: 410, height: 590)
    /// iPad 预览尺寸 (328x472 点) - 0.4x 缩放
    static let iPad_40Percent = CGSize(width: 328, height: 472)
    /// iPad 预览尺寸 (246x354 点) - 0.3x 缩放
    static let iPad_30Percent = CGSize(width: 246, height: 354)
    /// iPad 预览尺寸 (164x236 点) - 0.2x 缩放
    static let iPad_20Percent = CGSize(width: 164, height: 236)
    /// iPad 预览尺寸 (82x118 点) - 0.1x 缩放
    static let iPad_10Percent = CGSize(width: 82, height: 118)

    /// iPad Pro 11英寸的屏幕尺寸 (834x1194 点) - 1.0x 缩放
    static let iPadPro11 = CGSize(width: 834, height: 1194)
    /// iPad Pro 11" 预览尺寸 (751x1075 点) - 0.9x 缩放
    static let iPadPro11_90Percent = CGSize(width: 751, height: 1075)
    /// iPad Pro 11" 预览尺寸 (667x955 点) - 0.8x 缩放
    static let iPadPro11_80Percent = CGSize(width: 667, height: 955)
    /// iPad Pro 11" 预览尺寸 (584x836 点) - 0.7x 缩放
    static let iPadPro11_70Percent = CGSize(width: 584, height: 836)
    /// iPad Pro 11" 预览尺寸 (500x716 点) - 0.6x 缩放
    static let iPadPro11_60Percent = CGSize(width: 500, height: 716)
    /// iPad Pro 11" 预览尺寸 (417x597 点) - 0.5x 缩放
    static let iPadPro11_50Percent = CGSize(width: 417, height: 597)
    /// iPad Pro 11" 预览尺寸 (334x478 点) - 0.4x 缩放
    static let iPadPro11_40Percent = CGSize(width: 334, height: 478)
    /// iPad Pro 11" 预览尺寸 (250x358 点) - 0.3x 缩放
    static let iPadPro11_30Percent = CGSize(width: 250, height: 358)
    /// iPad Pro 11" 预览尺寸 (167x239 点) - 0.2x 缩放
    static let iPadPro11_20Percent = CGSize(width: 167, height: 239)
    /// iPad Pro 11" 预览尺寸 (83x119 点) - 0.1x 缩放
    static let iPadPro11_10Percent = CGSize(width: 83, height: 119)

    /// iPad Pro 12.9英寸的屏幕尺寸 (1024x1366 点) - 1.0x 缩放
    static let iPadPro12 = CGSize(width: 1024, height: 1366)
    /// iPad Pro 12.9" 预览尺寸 (922x1229 点) - 0.9x 缩放
    static let iPadPro12_90Percent = CGSize(width: 922, height: 1229)
    /// iPad Pro 12.9" 预览尺寸 (819x1093 点) - 0.8x 缩放
    static let iPadPro12_80Percent = CGSize(width: 819, height: 1093)
    /// iPad Pro 12.9" 预览尺寸 (717x957 点) - 0.7x 缩放
    static let iPadPro12_70Percent = CGSize(width: 717, height: 957)
    /// iPad Pro 12.9" 预览尺寸 (614x820 点) - 0.6x 缩放
    static let iPadPro12_60Percent = CGSize(width: 614, height: 820)
    /// iPad Pro 12.9" 预览尺寸 (512x683 点) - 0.5x 缩放
    static let iPadPro12_50Percent = CGSize(width: 512, height: 683)
    /// iPad Pro 12.9" 预览尺寸 (410x546 点) - 0.4x 缩放
    static let iPadPro12_40Percent = CGSize(width: 410, height: 546)
    /// iPad Pro 12.9" 预览尺寸 (307x410 点) - 0.3x 缩放
    static let iPadPro12_30Percent = CGSize(width: 307, height: 410)
    /// iPad Pro 12.9" 预览尺寸 (205x273 点) - 0.2x 缩放
    static let iPadPro12_20Percent = CGSize(width: 205, height: 273)
    /// iPad Pro 12.9" 预览尺寸 (102x137 点) - 0.1x 缩放
    static let iPadPro12_10Percent = CGSize(width: 102, height: 137)

    /// 标准Mac窗口的参考尺寸 (1024x768 点) - 1.0x 缩放
    static let mac = CGSize(width: 1024, height: 768)
    /// Mac 预览尺寸 (922x691 点) - 0.9x 缩放
    static let mac_90Percent = CGSize(width: 922, height: 691)
    /// Mac 预览尺寸 (819x614 点) - 0.8x 缩放
    static let mac_80Percent = CGSize(width: 819, height: 614)
    /// Mac 预览尺寸 (717x538 点) - 0.7x 缩放
    static let mac_70Percent = CGSize(width: 717, height: 538)
    /// Mac 预览尺寸 (614x461 点) - 0.6x 缩放
    static let mac_60Percent = CGSize(width: 614, height: 461)
    /// Mac 预览尺寸 (512x384 点) - 0.5x 缩放
    static let mac_50Percent = CGSize(width: 512, height: 384)
    /// Mac 预览尺寸 (410x307 点) - 0.4x 缩放
    static let mac_40Percent = CGSize(width: 410, height: 307)
    /// Mac 预览尺寸 (307x230 点) - 0.3x 缩放
    static let mac_30Percent = CGSize(width: 307, height: 230)
    /// Mac 预览尺寸 (205x154 点) - 0.2x 缩放
    static let mac_20Percent = CGSize(width: 205, height: 154)
    /// Mac 预览尺寸 (102x77 点) - 0.1x 缩放
    static let mac_10Percent = CGSize(width: 102, height: 77)

    /// iMac 27" 的屏幕原始尺寸 (5120x2890 点) - 1.0x 缩放
    static let iMac27 = CGSize(width: 5120, height: 2890)
    /// iMac 27" 预览尺寸 (4608x2601 点) - 0.9x 缩放
    static let iMac27_90Percent = CGSize(width: 4608, height: 2601)
    /// iMac 27" 预览尺寸 (4096x2312 点) - 0.8x 缩放
    static let iMac27_80Percent = CGSize(width: 4096, height: 2312)
    /// iMac 27" 预览尺寸 (3584x2023 点) - 0.7x 缩放
    static let iMac27_70Percent = CGSize(width: 3584, height: 2023)
    /// iMac 27" 预览尺寸 (3072x1734 点) - 0.6x 缩放
    static let iMac27_60Percent = CGSize(width: 3072, height: 1734)
    /// iMac 27" 预览尺寸 (2560x1445 点) - 0.5x 缩放
    static let iMac27_50Percent = CGSize(width: 2560, height: 1445)
    /// iMac 27" 预览尺寸 (2048x1156 点) - 0.4x 缩放
    static let iMac27_40Percent = CGSize(width: 2048, height: 1156)
    /// iMac 27" 预览尺寸 (1536x867 点) - 0.3x 缩放
    static let iMac27_30Percent = CGSize(width: 1536, height: 867)
    /// iMac 27" 中等预览尺寸，适合调试 (1024x578 点) - 0.2x 缩放
    static let iMac27_20Percent = CGSize(width: 1024, height: 578)
    /// iMac 27" 预览用小尺寸 (512x289 点) - 0.1x 缩放
    static let iMac27_10Percent = CGSize(width: 512, height: 289)
    
    /// MacBook Air/Pro 13" 的屏幕原始尺寸 (2550x1650 点) - 1.0x 缩放
    static let macBook13 = CGSize(width: 2550, height: 1650)
    /// MacBook 13" 预览尺寸 (2295x1485 点) - 0.9x 缩放
    static let macBook13_90Percent = CGSize(width: 2295, height: 1485)
    /// MacBook 13" 预览尺寸 (2040x1320 点) - 0.8x 缩放
    static let macBook13_80Percent = CGSize(width: 2040, height: 1320)
    /// MacBook 13" 预览尺寸 (1785x1155 点) - 0.7x 缩放
    static let macBook13_70Percent = CGSize(width: 1785, height: 1155)
    /// MacBook 13" 预览尺寸 (1530x990 点) - 0.6x 缩放
    static let macBook13_60Percent = CGSize(width: 1530, height: 990)
    /// MacBook 13" 预览尺寸 (1275x825 点) - 0.5x 缩放
    static let macBook13_50Percent = CGSize(width: 1275, height: 825)
    /// MacBook 13" 预览尺寸 (1020x660 点) - 0.4x 缩放
    static let macBook13_40Percent = CGSize(width: 1020, height: 660)
    /// MacBook 13" 预览尺寸 (765x495 点) - 0.3x 缩放
    static let macBook13_30Percent = CGSize(width: 765, height: 495)
    /// MacBook 13" 中等预览尺寸 (510x330 点) - 0.2x 缩放
    static let macBook13_20Percent = CGSize(width: 510, height: 330)
    /// MacBook 13" 预览用小尺寸 (255x165 点) - 0.1x 缩放
    static let macBook13_10Percent = CGSize(width: 255, height: 165)
    
    /// 判断尺寸是否为正方形
    ///
    /// 当宽度等于高度时返回true，否则返回false
    var isSquare: Bool {
        width == height
    }

    /// 获取尺寸的字符串描述
    ///
    /// 返回格式为"宽度x高度"的字符串，例如"390x844"
    var description: String {
        "\(width)x\(height)"
    }

    /// 是否宽度大于高度
    var isWidthGreaterThanHeight: Bool {
        width > height
    }

    /// 是否宽度小于高度
    var isWidthLessThanHeight: Bool {
        width < height
    }

    /// 是否宽度等于高度
    var isWidthEqualHeight: Bool {
        width == height
    }
}
