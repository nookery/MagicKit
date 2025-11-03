import SwiftUI

/// View扩展 - 提供Magic文字渐变色的便捷方法
public extension View {
    /// 为文字添加渐变色效果
    /// 
    /// 使用这个方法可以轻松为任何文字视图添加渐变色效果
    /// 支持多种渐变方向和预设颜色组合
    ///
    /// ```swift
    /// Text("Hello World")
    ///     .magicGradient(colors: [.blue, .purple])
    /// ```
    ///
    /// - Parameters:
    ///   - colors: 渐变色数组，至少需要2个颜色
    ///   - startPoint: 渐变起始点，默认为leading
    ///   - endPoint: 渐变结束点，默认为trailing
    /// - Returns: 带有渐变色的文字视图
    func magicGradient(
        colors: [Color],
        startPoint: UnitPoint = .leading,
        endPoint: UnitPoint = .trailing
    ) -> some View {
        self.foregroundStyle(
            LinearGradient(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint
            )
        )
    }
    
    /// 为文字添加水平渐变色效果（简化版本）
    /// 
    /// 这是`magicGradient`的简化版本，专门用于水平渐变
    /// 适用于大多数常见的文字渐变需求
    ///
    /// ```swift
    /// Text("Hello World")
    ///     .magicGradient(colors: [.blue, .purple])
    /// ```
    ///
    /// - Parameter colors: 渐变色数组，至少需要2个颜色
    /// - Returns: 带有水平渐变色的文字视图
    func magicGradient(colors: [Color]) -> some View {
        magicGradient(
            colors: colors,
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    /// 为文字添加预设的彩虹渐变色效果
    /// 
    /// 使用预设的彩虹渐变色，从红色到紫色
    ///
    /// ```swift
    /// Text("Rainbow")
    ///     .magicRainbowGradient()
    /// ```
    ///
    /// - Returns: 带有彩虹渐变色的文字视图
    func magicRainbowGradient() -> some View {
        magicGradient(
            colors: [.red, .orange, .yellow, .green, .blue, .indigo, .purple],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    /// 为文字添加预设的蓝紫渐变色效果
    /// 
    /// 使用预设的蓝紫渐变色，类似你提供的示例
    ///
    /// ```swift
    /// Text("Blue Purple")
    ///     .magicBluePurpleGradient()
    /// ```
    ///
    /// - Returns: 带有蓝紫渐变色的文字视图
    func magicBluePurpleGradient() -> some View {
        magicGradient(
            colors: [.blue, .purple],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    /// 为文字添加预设的日落渐变色效果
    /// 
    /// 使用预设的日落渐变色，从橙色到粉色
    ///
    /// ```swift
    /// Text("Sunset")
    ///     .magicSunsetGradient()
    /// ```
    ///
    /// - Returns: 带有日落渐变色的文字视图
    func magicSunsetGradient() -> some View {
        magicGradient(
            colors: [.orange, .pink, .purple],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    /// 为文字添加预设的海洋渐变色效果
    /// 
    /// 使用预设的海洋渐变色，从蓝色到青色
    ///
    /// ```swift
    /// Text("Ocean")
    ///     .magicOceanGradient()
    /// ```
    ///
    /// - Returns: 带有海洋渐变色的文字视图
    func magicOceanGradient() -> some View {
        magicGradient(
            colors: [.blue, .cyan, .teal],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    /// 为文字添加垂直渐变色效果
    /// 
    /// 从顶部到底部的垂直渐变
    ///
    /// ```swift
    /// Text("Vertical")
    ///     .magicVerticalGradient(colors: [.blue, .purple])
    /// ```
    ///
    /// - Parameter colors: 渐变色数组，至少需要2个颜色
    /// - Returns: 带有垂直渐变色的文字视图
    func magicVerticalGradient(colors: [Color]) -> some View {
        magicGradient(
            colors: colors,
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    /// 为文字添加对角线渐变色效果
    /// 
    /// 从左上角到右下角的对角线渐变
    ///
    /// ```swift
    /// Text("Diagonal")
    ///     .magicDiagonalGradient(colors: [.blue, .purple])
    /// ```
    ///
    /// - Parameter colors: 渐变色数组，至少需要2个颜色
    /// - Returns: 带有对角线渐变色的文字视图
    func magicDiagonalGradient(colors: [Color]) -> some View {
        magicGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Magic Text Gradient - Basic") {
    Text("Hello MagicKit!")
        .font(.system(size: 60, weight: .bold, design: .rounded))
        .magicGradient(colors: [.blue, .purple])
        .frame(width: 500, height: 100)
        .background(Color.gray.opacity(0.1))
}

#Preview("Magic Text Gradient - Rainbow") {
    Text("Rainbow")
        .font(.system(size: 50, weight: .bold, design: .rounded))
        .magicRainbowGradient()
        .frame(width: 400, height: 100)
        .background(Color.gray.opacity(0.1))
}

#Preview("Magic Text Gradient - Blue Purple") {
    Text("Blue Purple")
        .font(.system(size: 50, weight: .bold, design: .rounded))
        .magicBluePurpleGradient()
        .frame(width: 400, height: 100)
        .background(Color.gray.opacity(0.1))
}

#Preview("Magic Text Gradient - Sunset") {
    Text("Sunset")
        .font(.system(size: 50, weight: .bold, design: .rounded))
        .magicSunsetGradient()
        .frame(width: 400, height: 100)
        .background(Color.gray.opacity(0.1))
}

#Preview("Magic Text Gradient - Ocean") {
    Text("Ocean")
        .font(.system(size: 50, weight: .bold, design: .rounded))
        .magicOceanGradient()
        .frame(width: 400, height: 100)
        .background(Color.gray.opacity(0.1))
}

#Preview("Magic Text Gradient - Vertical") {
    Text("Vertical")
        .font(.system(size: 50, weight: .bold, design: .rounded))
        .magicVerticalGradient(colors: [.green, .blue])
        .frame(width: 400, height: 100)
        .background(Color.gray.opacity(0.1))
}

#Preview("Magic Text Gradient - Diagonal") {
    Text("Diagonal")
        .font(.system(size: 50, weight: .bold, design: .rounded))
        .magicDiagonalGradient(colors: [.red, .yellow])
        .frame(width: 400, height: 100)
        .background(Color.gray.opacity(0.1))
}

#Preview("Magic Text Gradient - Custom") {
    Text("Custom")
        .font(.system(size: 50, weight: .bold, design: .rounded))
        .magicGradient(
            colors: [.pink, .purple, .blue],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .frame(width: 400, height: 100)
        .background(Color.gray.opacity(0.1))
}
#endif
