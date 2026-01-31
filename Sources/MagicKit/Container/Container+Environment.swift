import SwiftUI

// MARK: - Environment Keys

private struct ContainerSizeKey: EnvironmentKey {
    static let defaultValue: CGSize = .zero
}

private struct ContainerScaleKey: EnvironmentKey {
    static let defaultValue: CGFloat = 1.0
}

private struct CaptureActionsKey: EnvironmentKey {
    static let defaultValue: CaptureActions = CaptureActions(
        capture: {},
        iOSAppStore: {},
        macOSAppStore: {},
        xcodeIcons: {}
    )
}

private struct IsDarkModeKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

struct CaptureActions {
    let capture: () -> Void
    let iOSAppStore: () -> Void
    let macOSAppStore: () -> Void
    let xcodeIcons: () -> Void
}

extension EnvironmentValues {
    var containerSize: CGSize {
        get { self[ContainerSizeKey.self] }
        set { self[ContainerSizeKey.self] = newValue }
    }

    var containerScale: CGFloat {
        get { self[ContainerScaleKey.self] }
        set { self[ContainerScaleKey.self] = newValue }
    }

    var captureActions: CaptureActions {
        get { self[CaptureActionsKey.self] }
        set { self[CaptureActionsKey.self] = newValue }
    }

    var isDarkMode: Bool {
        get { self[IsDarkModeKey.self] }
        set { self[IsDarkModeKey.self] = newValue }
    }
}
