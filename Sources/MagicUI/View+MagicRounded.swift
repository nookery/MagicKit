import SwiftUI

/// View扩展 - 提供Magic圆角配置的便捷方法
public extension View {
    /// 为视图添加圆角效果
    /// 
    /// 使用这个方法可以轻松为任何视图添加圆角效果
    /// 支持自定义圆角大小和样式
    ///
    /// ```swift
    /// Text("Hello World")
    ///     .magicRounded(radius: 12)
    /// ```
    ///
    /// - Parameters:
    ///   - radius: 圆角半径，默认为8
    ///   - style: 圆角样式，默认为continuous
    /// - Returns: 带有圆角效果的视图
    func magicRounded(
        radius: CGFloat = 8,
        style: RoundedCornerStyle = .continuous
    ) -> some View {
        self.clipShape(
            RoundedRectangle(cornerRadius: radius, style: style)
        )
    }
    
    /// 为视图添加小圆角效果
    /// 
    /// 使用预设的小圆角半径（4）
    ///
    /// ```swift
    /// Text("Small Rounded")
    ///     .magicRoundedSmall()
    /// ```
    ///
    /// - Returns: 带有小圆角效果的视图
    func magicRoundedSmall() -> some View {
        magicRounded(radius: 4)
    }
    
    /// 为视图添加中等圆角效果
    /// 
    /// 使用预设的中等圆角半径（8）
    ///
    /// ```swift
    /// Text("Medium Rounded")
    ///     .magicRoundedMedium()
    /// ```
    ///
    /// - Returns: 带有中等圆角效果的视图
    func magicRoundedMedium() -> some View {
        magicRounded(radius: 8)
    }
    
    /// 为视图添加大圆角效果
    /// 
    /// 使用预设的大圆角半径（16）
    ///
    /// ```swift
    /// Text("Large Rounded")
    ///     .magicRoundedLarge()
    /// ```
    ///
    /// - Returns: 带有大圆角效果的视图
    func magicRoundedLarge() -> some View {
        magicRounded(radius: 16)
    }
    
    /// 为视图添加超大圆角效果
    /// 
    /// 使用预设的超大圆角半径（24）
    ///
    /// ```swift
    /// Text("Extra Large Rounded")
    ///     .magicRoundedExtraLarge()
    /// ```
    ///
    /// - Returns: 带有超大圆角效果的视图
    func magicRoundedExtraLarge() -> some View {
        magicRounded(radius: 24)
    }
    
    /// 为视图添加胶囊形状效果
    /// 
    /// 使用胶囊形状（高度的一半作为圆角半径）
    ///
    /// ```swift
    /// Text("Capsule")
    ///     .magicCapsule()
    /// ```
    ///
    /// - Returns: 带有胶囊形状效果的视图
    func magicCapsule() -> some View {
        self.clipShape(Capsule())
    }
    
    /// 为视图添加圆形效果
    /// 
    /// 使用圆形形状
    ///
    /// ```swift
    /// Image(systemName: "star.fill")
    ///     .magicCircle()
    /// ```
    ///
    /// - Returns: 带有圆形效果的视图
    func magicCircle() -> some View {
        self.clipShape(Circle())
    }
    
    /// 为视图添加自定义圆角效果
    /// 
    /// 支持为不同角设置不同的圆角半径
    ///
    /// ```swift
    /// Text("Custom Rounded")
    ///     .magicRoundedCustom(
    ///         topLeading: 12,
    ///         topTrailing: 12,
    ///         bottomLeading: 4,
    ///         bottomTrailing: 4
    ///     )
    /// ```
    ///
    /// - Parameters:
    ///   - topLeading: 左上角圆角半径
    ///   - topTrailing: 右上角圆角半径
    ///   - bottomLeading: 左下角圆角半径
    ///   - bottomTrailing: 右下角圆角半径
    /// - Returns: 带有自定义圆角效果的视图
    func magicRoundedCustom(
        topLeading: CGFloat = 0,
        topTrailing: CGFloat = 0,
        bottomLeading: CGFloat = 0,
        bottomTrailing: CGFloat = 0
    ) -> some View {
        self.clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: topLeading,
                bottomLeadingRadius: bottomLeading,
                bottomTrailingRadius: bottomTrailing,
                topTrailingRadius: topTrailing
            )
        )
    }
    
    /// 为视图添加卡片样式圆角效果
    /// 
    /// 使用卡片样式的圆角配置（中等圆角）
    ///
    /// ```swift
    /// VStack { ... }
    ///     .magicCardRounded()
    /// ```
    ///
    /// - Returns: 带有卡片样式圆角效果的视图
    func magicCardRounded() -> some View {
        magicRounded(radius: 12, style: .continuous)
    }
    
    /// 为视图添加按钮样式圆角效果
    /// 
    /// 使用按钮样式的圆角配置（小圆角）
    ///
    /// ```swift
    /// Button("Click Me") { }
    ///     .magicButtonRounded()
    /// ```
    ///
    /// - Returns: 带有按钮样式圆角效果的视图
    func magicButtonRounded() -> some View {
        magicRounded(radius: 6, style: .continuous)
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Magic Rounded - Small") {
    Text("Small Rounded")
        .font(.title2)
        .foregroundColor(.white)
        .padding()
        .background(Color.blue)
        .magicRoundedSmall()
        .frame(width: 200, height: 60)
}

#Preview("Magic Rounded - Medium") {
    Text("Medium Rounded")
        .font(.title2)
        .foregroundColor(.white)
        .padding()
        .background(Color.green)
        .magicRoundedMedium()
        .frame(width: 200, height: 60)
}

#Preview("Magic Rounded - Large") {
    Text("Large Rounded")
        .font(.title2)
        .foregroundColor(.white)
        .padding()
        .background(Color.orange)
        .magicRoundedLarge()
        .frame(width: 200, height: 60)
}

#Preview("Magic Rounded - Extra Large") {
    Text("Extra Large")
        .font(.title2)
        .foregroundColor(.white)
        .padding()
        .background(Color.purple)
        .magicRoundedExtraLarge()
        .frame(width: 200, height: 60)
}

#Preview("Magic Rounded - Capsule") {
    Text("Capsule")
        .font(.title2)
        .foregroundColor(.white)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Color.red)
        .magicCapsule()
        .frame(width: 200, height: 60)
}

#Preview("Magic Rounded - Circle") {
    Image(systemName: "star.fill")
        .font(.system(size: 30))
        .foregroundColor(.white)
        .padding(20)
        .background(Color.yellow)
        .magicCircle()
        .frame(width: 80, height: 80)
}

#Preview("Magic Rounded - Custom") {
    Text("Custom")
        .font(.title2)
        .foregroundColor(.white)
        .padding()
        .background(Color.indigo)
        .magicRoundedCustom(
            topLeading: 20,
            topTrailing: 20,
            bottomLeading: 4,
            bottomTrailing: 4
        )
        .frame(width: 200, height: 60)
}

#Preview("Magic Rounded - Card Style") {
    VStack {
        Text("Card Title")
            .font(.headline)
        Text("Card Content")
            .font(.caption)
    }
    .foregroundColor(.white)
    .padding()
    .background(Color.teal)
    .magicCardRounded()
    .frame(width: 200, height: 80)
}

#Preview("Magic Rounded - Button Style") {
    Button("Click Me") {
        // Action
    }
    .font(.title3)
    .foregroundColor(.white)
    .padding()
    .background(Color.pink)
    .magicButtonRounded()
    .frame(width: 200, height: 60)
}
#endif
