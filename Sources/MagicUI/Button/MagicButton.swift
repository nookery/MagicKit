import SwiftUI
import OSLog

#if os(macOS)
import AppKit
#endif

/// 图标类型
public enum MagicButtonIcon {
    /// SF Symbols 系统图标
    case systemName(String)
    /// 自定义图标（仅 macOS）
    #if os(macOS)
    case customImage(NSImage)
    #endif
}

/// 一个功能丰富的按钮组件，支持多种样式、大小和形状
///
/// MagicButton 提供了丰富的自定义选项：
/// - 支持图标和文本组合
/// - 支持 SF Symbols 和自定义图标
/// - 提供主要和次要两种样式
/// - 支持四种尺寸：自动、小、中、大
/// - 提供多种形状选项
/// - 支持禁用状态和提示
/// - 支持弹出内容
/// - 支持唯一标识符
///
/// 基本用法：
/// ```swift
/// MagicButton(icon: .systemName("star"), action: {})
///     .magicTitle("按钮")
///     .magicStyle(.primary)
///     .magicId("star-button")
/// ```
public struct MagicButton: View {
    /// 按钮样式
    public enum Style {
        /// 主要样式，用于强调重要操作
        case primary
        /// 次要样式，用于普通操作
        case secondary
        /// 成功样式，用于表示操作成功或正向结果
        case success
        /// 警告样式，用于需要用户注意但非致命的问题
        case warning
        /// 危险样式，用于破坏性或不可逆操作
        case danger
        /// 信息样式，用于一般信息展示
        case info
        /// 中性样式，用于次要、低强调的操作
        case neutral
        /// 自定义颜色样式
        case custom(Color)
        /// 自定义背景视图
        case customView(AnyView)
    }

    /// 按钮大小
    public enum Size: Equatable {
        /// 迷你尺寸，适用于极度紧凑的布局
        case mini
        /// 自动模式，占据尽可能多的空间
        case auto
        /// 小尺寸，适用于紧凑布局
        case small
        /// 常规尺寸，默认选项
        case regular
        /// 大尺寸，适用于强调显示
        case large
        /// 超大尺寸，适用于特殊场景
        case extraLarge
        /// 巨大尺寸，适用于焦点元素
        case huge
        /// 自定义尺寸
        case custom(CGFloat)

        /// 获取固定尺寸的按钮大小
        var fixedSize: CGFloat {
            switch self {
            case .mini:
                return 24
            case .auto:
                return 0 // 自动模式不使用固定值
            case .small:
                return 32
            case .regular:
                return 40
            case .large:
                return 50
            case .extraLarge:
                return 64
            case .huge:
                return 80
            case let .custom(size):
                return size
            }
        }

        /// 获取图标大小
        func iconSize(containerSize: CGFloat) -> CGFloat {
            switch self {
            case .mini:
                return 10
            case .auto:
                return 20 // 自动模式下使用默认大小
            case .small:
                return 12
            case .regular:
                return 15
            case .large:
                return 20
            case .extraLarge:
                return 24
            case .huge:
                return 32
            case let .custom(size):
                return size * 0.4
            }
        }

        /// 获取字体大小
        var font: Font {
            switch self {
            case .mini:
                return .caption2
            case .auto:
                return .body
            case .small:
                return .caption
            case .regular:
                return .body
            case .large:
                return .title3
            case .extraLarge:
                return .title2
            case .huge:
                return .title
            case .custom:
                return .body
            }
        }

        /// 获取水平内边距
        var horizontalPadding: CGFloat {
            switch self {
            case .mini:
                return 6
            case .auto:
                return 16
            case .small:
                return 8
            case .regular:
                return 12
            case .large:
                return 16
            case .extraLarge:
                return 20
            case .huge:
                return 24
            case .custom:
                return 16
            }
        }

        /// 获取垂直内边距
        var verticalPadding: CGFloat {
            switch self {
            case .mini:
                return 2
            case .auto:
                return 12
            case .small:
                return 4
            case .regular:
                return 8
            case .large:
                return 12
            case .extraLarge:
                return 16
            case .huge:
                return 20
            case .custom:
                return 12
            }
        }
    }

    /// 按钮形状
    public enum Shape {
        /// 圆形，当没有标题时自动采用正圆形状
        case circle
        /// 胶囊形（两端圆角），适用于带文本的按钮
        case capsule
        /// 矩形（无圆角），适用于网格布局
        case rectangle
        /// 圆角矩形（固定圆角），通用选项
        case roundedRectangle
        /// 圆角正方形，适用于图标按钮
        case roundedSquare
        /// 自定义圆角矩形，可以为每个角设置不同的圆角半径
        /// - Parameters:
        ///   - topLeft: 左上角圆角半径
        ///   - topRight: 右上角圆角半径
        ///   - bottomLeft: 左下角圆角半径
        ///   - bottomRight: 右下角圆角半径
        case customRoundedRectangle(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat)
        /// 自定义胶囊形，可以为左右两端设置不同的圆角半径
        /// - Parameters:
        ///   - leftRadius: 左侧圆角半径
        ///   - rightRadius: 右侧圆角半径
        case customCapsule(leftRadius: CGFloat, rightRadius: CGFloat)

        /// 获取形状的圆角半径
        public var cornerRadius: CGFloat {
            switch self {
            case .circle:
                return .infinity
            case .capsule:
                return .infinity
            case .rectangle:
                return 0
            case .roundedRectangle:
                return 8
            case .roundedSquare:
                return 12
            case .customRoundedRectangle:
                return 0 // 由自定义值决定
            case .customCapsule:
                return 0 // 由自定义值决定
            }
        }
    }

    /// 按钮形状的显示时机
    public enum ShapeVisibility {
        /// 始终显示形状
        case always
        /// 仅在悬停时显示形状
        case onHover
    }

    /// 加载动画样式
    public typealias LoadingStyle = MagicLoadingView.Style

    // MARK: - Properties

    /// 按钮唯一标识符
    var id: String?
    /// 按钮唯一标识符绑定（可选）
    var idBinding: Binding<String>?
    /// 按钮内部标识符（避免与 SwiftUI id 修饰符冲突）
    public var buttonId: String?
    /// 按钮图标
    let icon: MagicButtonIcon?
    /// 按钮标题（可选）
    let title: String?
    /// 按钮样式
    let style: Style
    /// 按钮大小
    let size: Size
    /// 按钮形状
    let shape: Shape
    /// 形状显示时机
    let shapeVisibility: ShapeVisibility
    /// 禁用状态的提示文本
    let disabledReason: String?
    /// 弹出内容
    let popoverContent: AnyView?
    /// 点击动作（可以是简单动作或带完成回调的动作）
    let action: ((@escaping () -> Void) -> Void)?
    /// 自定义背景色
    let customBackgroundColor: Color?
    /// 是否启用防重复点击
    let preventDoubleClick: Bool
    /// 加载动画样式
    let loadingStyle: LoadingStyle

    @State internal var isHovering = false
    @State internal var containerSize: CGFloat = 0
    @State internal var showingDisabledPopover = false
    @State internal var showingPopover = false
    @State internal var shouldShowTitle = false
    @State internal var isLoading = false
    @State private var autoGeneratedId: String = "magic-button-\(UUID().uuidString)"
    @Environment(\.colorScheme) var colorScheme

    public var body: some View {
        let currentViewId = idBinding?.wrappedValue ?? id ?? autoGeneratedId
        // 外层容器
        let container = Group {
            if size == .auto {
                containerContent
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                containerContent
                    .frame(
                        width: isCircularShape ? size.fixedSize : size.fixedSize,
                        height: size.fixedSize
                    )
            }
        }

        return container
            .background(shouldShowShape ? Rectangle()
                .fill(Color.clear)
                .magicShape(
                    shape,
                    style: style,
                    backgroundColor: backgroundColor,
                    shadowColor: shadowColor,
                    buttonSize: buttonSize
                ) : nil)
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isHovering = hovering
                }
            }
            .scaleEffect(isHovering ? 1.05 : 1.0)
            .shadow(
                color: isHovering ? Color.accentColor.opacity(0.2) : .clear,
                radius: isHovering ? 8 : 0,
                y: isHovering ? 2 : 0
            )
            .onTapGesture {
                guard disabledReason == nil else {
                    showingDisabledPopover = true
                    return
                }

                guard !(preventDoubleClick && isLoading) else {
                    return
                }

                handleTap()
            }
            .popover(isPresented: $showingPopover) {
                if let content = popoverContent {
                    content
                }
            }
            .popover(isPresented: $showingDisabledPopover) {
                if let reason = disabledReason {
                    Text(reason)
                        .padding()
                }
            }
            .onAppear {
                // 确保初始状态正确设置
                if showingPopover {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.showingPopover = true
                    }
                }
            }
            // 使用稳定的 id，避免未提供 id 时每次渲染生成新 UUID 触发重建
            .id(currentViewId)
    }

    private var isCircularShape: Bool {
        if case .circle = shape {
            return title == nil
        }
        return false
    }

    private var buttonSize: CGFloat {
        if case .auto = size {
            let availableSize = containerSize - (size.horizontalPadding * 2)
            return min(max(availableSize, Size.small.fixedSize), Size.huge.fixedSize)
        }
        return size.fixedSize
    }

    private var shouldShowShape: Bool {
        switch shapeVisibility {
        case .always:
            return true
        case .onHover:
            return isHovering
        }
    }
}

// MARK: - MagicButton Extensions

extension MagicButton {
    /// 设置按钮的唯一标识符
    /// - Parameter id: 新的标识符
    /// - Returns: 更新后的 MagicButton
    public func magicId(_ id: String?) -> MagicButton {
        var newButton = self
        newButton.id = id
        newButton.idBinding = nil
        newButton.buttonId = id
        return newButton
    }
    
    /// 设置按钮的动态 ID 绑定
    /// - Parameter idBinding: ID 绑定
    /// - Returns: 更新后的 MagicButton
    public func magicId(_ idBinding: Binding<String>) -> MagicButton {
        var newButton = self
        newButton.id = nil
        newButton.idBinding = idBinding
        newButton.buttonId = idBinding.wrappedValue
        return newButton
    }
}

#if DEBUG
#Preview("Basic") {
    BasicButtonsPreview()
}
#endif
