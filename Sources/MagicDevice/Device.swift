import Foundation
import SwiftUI

public enum DeviceType: Equatable {
    case Mac
    case iPhone
    case iPad
}

public enum AppleDevice: String, Equatable, CaseIterable {
    case iMac = "iMac 27\""
    case MacBook = "MacBook Pro 16\""
    case iPhoneBig = "iPhone 14 Pro Max"
    case iPhoneSmall = "iPhone 14 Pro"
    case iPad = "iPad Pro 13\""

    public var isMac: Bool {
        self.type == .Mac
    }

    public var isiPhone: Bool {
        self.type == .iPhone
    }

    public var isiPad: Bool {
        self.type == .iPad
    }

    public var type: DeviceType {
        switch self {
        case .iMac:
            return .Mac
        case .MacBook:
            return .Mac
        case .iPad:
            return .iPad
        case .iPhoneBig:
            return .iPhone
        case .iPhoneSmall:
            return .iPhone
        }
    }

    public var name: String {
        self.rawValue
    }
    
    public var description: String {
        self.rawValue
    }

    public var systemImageName: String {
        switch self {
        case .iMac:
            return "desktopcomputer"
        case .MacBook:
            return "laptopcomputer"
        case .iPad:
            return "ipad"
        case .iPhoneBig:
            return "iphone"
        case .iPhoneSmall:
            return "iphone"
        }
    }

    public var width: CGFloat {
        switch self {
        case .iMac:
            2880
        case .MacBook:
            2880
        case .iPhoneBig:
            1290
        case .iPhoneSmall:
            1242
        case .iPad:
            2048
        }
    }

    public var height: CGFloat {
        switch self {
        case .iMac:
            1800
        case .MacBook:
            1800
        case .iPhoneBig:
            2796
        case .iPhoneSmall:
            2208
        case .iPad:
            2732
        }
    }
}
