import SwiftUI

extension MagicButton {
    // MARK: - Initialization

    /// 创建一个 MagicButton
    /// - Parameters 详见 `MagicButton` 文档注释
    public init(
        id: String? = nil,
        icon: MagicButtonIcon? = nil,
        title: String? = nil,
        style: Style = .primary,
        size: Size = .regular,
        shape: Shape = .roundedRectangle,
        shapeVisibility: ShapeVisibility = .always,
        disabledReason: String? = nil,
        popoverContent: AnyView? = nil,
        customBackgroundColor: Color? = nil,
        preventDoubleClick: Bool = true,
        loadingStyle: LoadingStyle = .spinner,
        action: ((@escaping () -> Void) -> Void)? = nil
    ) {
        self.id = id
        self.idBinding = nil
        self.buttonId = id
        if icon == nil && title == nil {
            self.icon = .systemName("circle")
            self.title = nil
        } else {
            self.icon = icon
            self.title = title
        }
        self.style = style
        self.size = size
        self.shape = shape
        self.shapeVisibility = shapeVisibility
        self.disabledReason = disabledReason
        self.popoverContent = popoverContent
        self.action = action
        self.customBackgroundColor = customBackgroundColor
        self.preventDoubleClick = preventDoubleClick
        self.loadingStyle = loadingStyle
    }

    /// 创建一个支持动态 ID 绑定的 MagicButton
    public init(
        idBinding: Binding<String>,
        icon: MagicButtonIcon? = nil,
        title: String? = nil,
        style: Style = .primary,
        size: Size = .regular,
        shape: Shape = .roundedRectangle,
        shapeVisibility: ShapeVisibility = .always,
        disabledReason: String? = nil,
        popoverContent: AnyView? = nil,
        customBackgroundColor: Color? = nil,
        preventDoubleClick: Bool = true,
        loadingStyle: LoadingStyle = .spinner,
        action: ((@escaping () -> Void) -> Void)? = nil
    ) {
        self.id = nil
        self.idBinding = idBinding
        if icon == nil && title == nil {
            self.icon = .systemName("circle")
            self.title = nil
        } else {
            self.icon = icon
            self.title = title
        }
        self.style = style
        self.size = size
        self.shape = shape
        self.shapeVisibility = shapeVisibility
        self.disabledReason = disabledReason
        self.popoverContent = popoverContent
        self.action = action
        self.customBackgroundColor = customBackgroundColor
        self.preventDoubleClick = preventDoubleClick
        self.loadingStyle = loadingStyle
    }

    /// 创建一个 MagicButton（向后兼容 - 使用 String 图标名称）
    public init(
        id: String? = nil,
        icon: String,
        title: String? = nil,
        style: Style = .primary,
        size: Size = .regular,
        shape: Shape = .roundedRectangle,
        shapeVisibility: ShapeVisibility = .always,
        disabledReason: String? = nil,
        popoverContent: AnyView? = nil,
        customBackgroundColor: Color? = nil,
        preventDoubleClick: Bool = true,
        loadingStyle: LoadingStyle = .spinner,
        action: ((@escaping () -> Void) -> Void)? = nil
    ) {
        self.init(
            id: id,
            icon: .systemName(icon),
            title: title,
            style: style,
            size: size,
            shape: shape,
            shapeVisibility: shapeVisibility,
            disabledReason: disabledReason,
            popoverContent: popoverContent,
            customBackgroundColor: customBackgroundColor,
            preventDoubleClick: preventDoubleClick,
            loadingStyle: loadingStyle,
            action: action
        )
    }
}

// MARK: - Simple factory helpers
extension MagicButton {
    /// 创建一个简单的 MagicButton（回调无完成闭包）
    public static func simple(
        id: String? = nil,
        icon: MagicButtonIcon? = nil,
        title: String? = nil,
        style: Style = .primary,
        size: Size = .regular,
        shape: Shape = .roundedRectangle,
        shapeVisibility: ShapeVisibility = .always,
        disabledReason: String? = nil,
        popoverContent: AnyView? = nil,
        customBackgroundColor: Color? = nil,
        preventDoubleClick: Bool = true,
        loadingStyle: LoadingStyle = .spinner,
        action: @escaping () -> Void
    ) -> MagicButton {
        return MagicButton(
            id: id,
            icon: icon,
            title: title,
            style: style,
            size: size,
            shape: shape,
            shapeVisibility: shapeVisibility,
            disabledReason: disabledReason,
            popoverContent: popoverContent,
            customBackgroundColor: customBackgroundColor,
            preventDoubleClick: preventDoubleClick,
            loadingStyle: loadingStyle
        ) { completion in
            action()
            completion()
        }
    }

    /// 创建一个支持动态 ID 绑定的简单 MagicButton
    public static func simple(
        idBinding: Binding<String>,
        icon: MagicButtonIcon? = nil,
        title: String? = nil,
        style: Style = .primary,
        size: Size = .regular,
        shape: Shape = .roundedRectangle,
        shapeVisibility: ShapeVisibility = .always,
        disabledReason: String? = nil,
        popoverContent: AnyView? = nil,
        customBackgroundColor: Color? = nil,
        preventDoubleClick: Bool = true,
        loadingStyle: LoadingStyle = .spinner,
        action: @escaping () -> Void
    ) -> MagicButton {
        return MagicButton(
            idBinding: idBinding,
            icon: icon,
            title: title,
            style: style,
            size: size,
            shape: shape,
            shapeVisibility: shapeVisibility,
            disabledReason: disabledReason,
            popoverContent: popoverContent,
            customBackgroundColor: customBackgroundColor,
            preventDoubleClick: preventDoubleClick,
            loadingStyle: loadingStyle
        ) { completion in
            action()
            completion()
        }
    }

    /// 创建一个简单的 MagicButton（使用 String 图标名称）
    public static func simple(
        id: String? = nil,
        icon: String,
        title: String? = nil,
        style: Style = .primary,
        size: Size = .regular,
        shape: Shape = .roundedRectangle,
        shapeVisibility: ShapeVisibility = .always,
        disabledReason: String? = nil,
        popoverContent: AnyView? = nil,
        customBackgroundColor: Color? = nil,
        preventDoubleClick: Bool = true,
        loadingStyle: LoadingStyle = .spinner,
        action: @escaping () -> Void
    ) -> MagicButton {
        return MagicButton(
            id: id,
            icon: .systemName(icon),
            title: title,
            style: style,
            size: size,
            shape: shape,
            shapeVisibility: shapeVisibility,
            disabledReason: disabledReason,
            popoverContent: popoverContent,
            customBackgroundColor: customBackgroundColor,
            preventDoubleClick: preventDoubleClick,
            loadingStyle: loadingStyle
        ) { completion in
            action()
            completion()
        }
    }

    /// 创建一个支持动态 ID 绑定的简单 MagicButton（使用 String 图标名称）
    public static func simple(
        idBinding: Binding<String>,
        icon: String,
        title: String? = nil,
        style: Style = .primary,
        size: Size = .regular,
        shape: Shape = .roundedRectangle,
        shapeVisibility: ShapeVisibility = .always,
        disabledReason: String? = nil,
        popoverContent: AnyView? = nil,
        customBackgroundColor: Color? = nil,
        preventDoubleClick: Bool = true,
        loadingStyle: LoadingStyle = .spinner,
        action: @escaping () -> Void
    ) -> MagicButton {
        return MagicButton(
            idBinding: idBinding,
            icon: .systemName(icon),
            title: title,
            style: style,
            size: size,
            shape: shape,
            shapeVisibility: shapeVisibility,
            disabledReason: disabledReason,
            popoverContent: popoverContent,
            customBackgroundColor: customBackgroundColor,
            preventDoubleClick: preventDoubleClick,
            loadingStyle: loadingStyle
        ) { completion in
            action()
            completion()
        }
    }
}

#if DEBUG
#Preview("Basic") {
    BasicButtonsPreview()
}
#endif

