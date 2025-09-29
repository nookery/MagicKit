import SwiftUI

extension MagicButton {
    var foregroundColor: Color {
        if disabledReason != nil || (isLoading && preventDoubleClick) {
            return .gray
        }
        switch style {
        case .primary:
            return isHovering ? .white : .accentColor
        case .secondary:
            return .primary
        case .success:
            return isHovering ? .white : .green
        case .warning:
            return isHovering ? .white : .orange
        case .danger:
            return isHovering ? .white : .red
        case .info:
            return isHovering ? .white : .blue
        case .neutral:
            return .secondary
        case let .custom(color):
            return isHovering ? .white : color
        case .customView:
            return .primary
        }
    }

    var backgroundColor: Color {
        if disabledReason != nil || (isLoading && preventDoubleClick) {
            return Color.gray.opacity(0.1)
        }

        switch style {
        case .primary:
            return isHovering ? .accentColor : .accentColor.opacity(0.1)
        case .secondary:
            return isHovering ?
                Color.primary.opacity(colorScheme == .dark ? 0.2 : 0.15) :
                Color.primary.opacity(0.1)
        case .success:
            return isHovering ? Color.green : Color.green.opacity(0.12)
        case .warning:
            return isHovering ? Color.orange : Color.orange.opacity(0.12)
        case .danger:
            return isHovering ? Color.red : Color.red.opacity(0.12)
        case .info:
            return isHovering ? Color.blue : Color.blue.opacity(0.12)
        case .neutral:
            return Color.secondary.opacity(colorScheme == .dark ? 0.18 : 0.12)
        case let .custom(color):
            return isHovering ? color : color.opacity(0.1)
        case .customView:
            return .clear
        }
    }

    var shadowColor: Color {
        switch style {
        case .primary:
            return isHovering ? .accentColor.opacity(0.3) : .clear
        case .secondary:
            return isHovering ? Color.primary.opacity(0.2) : .clear
        case .success:
            return isHovering ? Color.green.opacity(0.25) : .clear
        case .warning:
            return isHovering ? Color.orange.opacity(0.25) : .clear
        case .danger:
            return isHovering ? Color.red.opacity(0.25) : .clear
        case .info:
            return isHovering ? Color.blue.opacity(0.25) : .clear
        case .neutral:
            return isHovering ? Color.secondary.opacity(0.2) : .clear
        case let .custom(color):
            return isHovering ? color.opacity(0.3) : .clear
        case .customView:
            return .clear
        }
    }
}

#if DEBUG
#Preview("MagicButton+Color - Theming") {
    BasicButtonsPreview()
}
#endif
