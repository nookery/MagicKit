import SwiftUI

public extension Image {
    /**
        创建咖啡卷图标

        ## 参数
        - `useDefaultBackground`: 是否使用默认的绿色渐变背景，默认为 true
        - `plateColor`: 盘子边框的颜色，默认为白色
        - `size`: 图标的大小，如果为 nil 则使用容器默认大小

        ## 返回值
        一个包含咖啡卷图标的视图

        ## 示例
        ```swift
        // 创建默认咖啡卷图标
        Image.makeCoffeeReelIcon()

        // 创建自定义咖啡卷图标
        Image.makeCoffeeReelIcon(
            useDefaultBackground: false,
            plateColor: .brown,
            size: 100
        )
        ```
     */
    static func makeCoffeeReelIcon(
        useDefaultBackground: Bool = true,
        plateColor: Color = .white,
        handleRotation: Double = 30,
        size: CGFloat? = nil
    ) -> some View {
        IconContainer(size: size) {
            CoffeeReelIcon(
                useDefaultBackground: useDefaultBackground,
                plateColor: plateColor,
                handleRotation: handleRotation
            )
        }
    }
}

/**
 * 咖啡卷图标的内部实现
 * 定义了咖啡卷图标的视觉表现，包括背景、盘子、咖啡杯和装饰性圆点等元素
 * 它被 `Image.makeCoffeeReelIcon` 方法使用，通常不需要直接使用此结构体
 */
struct CoffeeReelIcon: View {
    /// 是否显示咖啡色圆形装饰
    let showBrownCircle: Bool = true
    /// 是否显示红色圆形装饰（当前未启用）
    let showRedCircle: Bool = false
    /// 是否使用默认的绿色渐变背景
    let useDefaultBackground: Bool
    /// 盘子边框的颜色
    let plateColor: Color
    /// 手柄旋转角度
    let handleRotation: Double
    /// 咖啡杯的颜色
    let cupColor: Color = Color(red: 0.8, green: 0.6, blue: 0.2)

    /**
        初始化咖啡卷图标

        ## 参数
        - `useDefaultBackground`: 是否使用默认背景
        - `plateColor`: 盘子边框颜色
        - `handleRotation`: 手柄旋转角度，默认为30度
     */
    init(useDefaultBackground: Bool = true, plateColor: Color = .white, handleRotation: Double = 30) {
        self.useDefaultBackground = useDefaultBackground
        self.plateColor = plateColor
        self.handleRotation = handleRotation
    }

    /// 咖啡卷图标视图的主体
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let plateSize = size * 0.6 // 盘子尺寸略小于整体视图
            let cupSize = plateSize * 0.8
            let brownCircleSize = cupSize * 1
            let redCircleSize = brownCircleSize * 0.5
            let dotSize = redCircleSize * 0.5
            let dotOffset = redCircleSize * 0.5
            let centerDotSize = dotSize * 0.6
            let handleWidth = cupSize * 0.16
            let handleLength = cupSize * 0.7

            ZStack {
                // 背景层：绿色到蓝色的渐变，营造自然清新的感觉
                if useDefaultBackground {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.2, green: 0.5, blue: 0.4),
                            Color(red: 0.2, green: 0.5, blue: 0.7),
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                } else {
                    Color.clear
                }

                // 盘子层：使用遮罩创建带手柄的盘子效果
                Circle()
                    .stroke(plateColor, lineWidth: plateSize - cupSize)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 2, y: 3)
                    .frame(width: plateSize, height: plateSize)
                    .mask {
                        // 咖啡杯手柄：通过遮罩在盘子边缘创建手柄形状
                        Circle()
                            .stroke(.white, lineWidth: plateSize - cupSize)
                            .frame(width: plateSize, height: plateSize)
                            .overlay {
                                Capsule()
                                    .frame(width: handleLength, height: handleWidth)
                                    .offset(x: cupSize * 0.3)
                                    .rotationEffect(.degrees(handleRotation))
                                    .shadow(color: .black.opacity(0.3), radius: 3, x: 2, y: 2)
                                    .blendMode(.destinationOut)
                            }
                    }

                // 咖啡杯层：空心的圆形轮廓，模拟咖啡杯的形状
                Circle()
                    .fill(Color.clear)
                    .stroke(cupColor, lineWidth: 14)
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 2, y: 2)
                    .frame(width: cupSize, height: cupSize)

                // 装饰层：咖啡色圆形和装饰性圆点
                if showBrownCircle {
                    Circle()
                        .fill(Color(red: 0.35, green: 0.22, blue: 0.17))
                        .frame(width: brownCircleSize, height: brownCircleSize)
                        .mask {
                            Circle()
                                .fill(Color.white)
                                .frame(width: brownCircleSize, height: brownCircleSize)
                                .overlay {
                                    ZStack {
                                        // 四个装饰圆点：通过数学计算均匀分布在圆周上
                                        ForEach(0 ..< 4) { index in
                                            Circle()
                                                .frame(width: dotSize, height: dotSize)
                                                .offset(
                                                    x: dotOffset * cos(Double(index) * .pi / 2),
                                                    y: dotOffset * sin(Double(index) * .pi / 2)
                                                )
                                                .blendMode(.destinationOut)
                                        }
                                        // 中心装饰圆点
                                        Circle()
                                            .frame(width: centerDotSize, height: centerDotSize)
                                            .blendMode(.destinationOut)
                                    }
                                }
                        }
                }
            }
        }
    }
}

/**
 * 咖啡卷图标预览
 * 展示不同配置下的咖啡卷图标效果
 */
#Preview("Coffee Reel Icon") {
    TabView {
        // 默认配置：绿色背景，白色盘子
        VStack {
            IconPreviewHelper(title: "Coffee Reel Icon (Default)") {
                Image.makeCoffeeReelIcon()
            }
        }
        .tabItem {
            Label("默认", systemImage: "leaf.fill")
        }

        // 自定义配置：无背景，棕色盘子
        VStack {
            Image.makeCoffeeReelIcon(
                useDefaultBackground: false,
                plateColor: .brown
            )
            .frame(height: 200)
            .frame(width: 200)
        }
        .tabItem {
            Label("棕色盘子", systemImage: "circle.fill")
        }

        // 自定义配置：无背景，蓝色盘子
        VStack {
            Image.makeCoffeeReelIcon(
                useDefaultBackground: false,
                plateColor: .blue
            )
            .frame(height: 200)
            .frame(width: 200)
        }
        .tabItem {
            Label("蓝色盘子", systemImage: "circle.fill")
        }

        // 自定义配置：无背景，红色盘子
        VStack {
            Image.makeCoffeeReelIcon(
                useDefaultBackground: false,
                plateColor: .red
            )
            .frame(width: 200)
            .frame(height: 200)
        }
        .tabItem {
            Label("红色盘子", systemImage: "circle.fill")
        }

        // 自定义配置：不同手柄角度
        VStack(spacing: 20) {
            Image.makeCoffeeReelIcon(
                useDefaultBackground: true,
                handleRotation: -90
            )
            .frame(height: 200)
            .frame(width: 200)
            
            // 0度手柄
            Image.makeCoffeeReelIcon(
                useDefaultBackground: true,
                handleRotation: 0
            )
            .frame(height: 200)
            .frame(width: 200)

            // 30度手柄
            Image.makeCoffeeReelIcon(
                useDefaultBackground: true,
                handleRotation: 30
            )
            .frame(height: 200)
            .frame(width: 200)

            // 45度手柄
            Image.makeCoffeeReelIcon(
                useDefaultBackground: true,
                handleRotation: 45
            )
            .frame(height: 200)
            .frame(width: 200)

            // 90度手柄
            Image.makeCoffeeReelIcon(
                useDefaultBackground: true,
                handleRotation: 90
            )
            .frame(height: 200)
            .frame(width: 200)
        }
        .tabItem {
            Label("手柄角度", systemImage: "rotate.right")
        }
    }
}
