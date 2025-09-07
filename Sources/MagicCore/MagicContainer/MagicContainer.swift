import SwiftUI
import Foundation

#if os(macOS)
import AppKit
#endif

/// 视图容器，提供多种实用功能
struct MagicContainer<Content: View>: View {
    // MARK: - Properties
    private let content: Content
    private let showsIndicators: Bool
    private let containerHeight: CGFloat
    private let containerWidth: CGFloat
    @Environment(\.colorScheme) private var systemColorScheme
    @State private var isDarkMode: Bool = false
    @State private var selectedSize: PreviewSize = .full
    
    // MARK: - Initialization
    /// 创建主题预览容器
    /// - Parameters:
    ///   - showsIndicators: 是否显示滚动条，默认为 true
    ///   - containerHeight: 容器高度，默认为 750
    ///   - containerWidth: 容器宽度，可选
    ///   - content: 要预览的内容视图
    public init(
        showsIndicators: Bool = true,
        containerHeight: CGFloat = 750,
        containerWidth: CGFloat = 500,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.showsIndicators = showsIndicators
        self.containerHeight = containerHeight
        self.containerWidth = containerWidth
    }
    
    // MARK: - Body
    public var body: some View {
        ZStack {
            // MARK: Content Layer
            VStack(spacing: 0) {
                // MARK: Toolbar
                MagicContainerToolbar(
                    selectedSize: $selectedSize,
                    isDarkMode: $isDarkMode,
                    captureAction: captureView,
                    appStoreCaptureAction: captureAppStoreView,
                    macAppStoreCaptureAction: captureMacAppStoreView
                )
                .frame(maxWidth: .infinity)
                
                // MARK: Divider
                Divider().padding(.bottom, 10)
                
                // MARK: Content Area
                ScrollView([.horizontal, .vertical], showsIndicators: showsIndicators) {
                    SmartScaleView(
                        content: content,
                        selectedSize: selectedSize
                    )
                    .padding(.horizontal, selectedSize == .full ? 16 : 40)
                    .padding(.vertical, selectedSize == .full ? 12 : 20)
                }
            }
        }
        .background(.background)
        .environment(\.colorScheme, isDarkMode ? .dark : .light)
        .frame(width: containerWidth, height: containerHeight)
        .onAppear {
            // 初始化时跟随系统主题
            isDarkMode = systemColorScheme == .dark
        }
        .withMagicToast()
    }
}

// MARK: - Action

extension MagicContainer { 
    /// 截图功能实现 (使用snapshot方法)
    private func captureView() {
        #if os(macOS)
        let result = MagicImage.snapshot(content, title: "MagicContainer_\(MagicImage.getTimeString())")
        if result.contains("失败") {
            MagicMessageProvider.shared.error(result)
        } else {
            MagicMessageProvider.shared.info(result)
        }
        #endif
    }
    
    /// App Store截图功能实现 (生成多种分辨率的图片)
    private func captureAppStoreView() {
        #if os(macOS)
        // App Store要求的iPhone截图尺寸
        let iPhoneSizes: [(String, CGSize)] = [
            ("iPhone_6.9inch", CGSize(width: 1290, height: 2796)), // iPhone 14 Pro Max, etc.
            ("iPhone_6.5inch", CGSize(width: 1284, height: 2778)), // iPhone 12 Pro Max, etc.
            ("iPhone_5.8inch", CGSize(width: 1170, height: 2532)), // iPhone 12, etc.
            ("iPhone_5.5inch", CGSize(width: 1242, height: 2208)), // iPhone 8 Plus, etc.
            ("iPhone_4.7inch", CGSize(width: 750, height: 1334)),  // iPhone SE 2nd gen, etc.
        ]
        
        // App Store要求的iPad截图尺寸
        let iPadSizes: [(String, CGSize)] = [
            ("iPad_12.9inch", CGSize(width: 2048, height: 2732)), // iPad Pro 12.9"
            ("iPad_11inch", CGSize(width: 1668, height: 2388)),   // iPad Pro 11"
            ("iPad_10.5inch", CGSize(width: 1668, height: 2224)), // iPad Pro 10.5"
        ]
        
        // 为每种尺寸生成截图
        for (name, size) in iPhoneSizes + iPadSizes {
            let scaledContent = content
                .frame(width: size.width/2, height: size.height/2) // 按比例缩小以适应视图
            
            let result = MagicImage.snapshot(scaledContent, title: "\(name)_\(MagicImage.getTimeString())")
            if result.contains("失败") {
                MagicMessageProvider.shared.error("生成 \(name) 截图失败")
                return
            }
        }
        
        MagicMessageProvider.shared.info("已生成App Store所需的各种尺寸截图")
        #endif
    }
    
    /// macOS App Store截图功能实现 (生成多种分辨率的图片)
    private func captureMacAppStoreView() {
        #if os(macOS)
        // App Store要求的macOS截图尺寸 (16:10比例)
        let macOSSizes: [(String, CGSize)] = [
            ("macOS_1280x800", CGSize(width: 1280, height: 800)),
            ("macOS_1440x900", CGSize(width: 1440, height: 900)),
            ("macOS_2560x1600", CGSize(width: 2560, height: 1600)),
            ("macOS_2880x1800", CGSize(width: 2880, height: 1800))
        ]
        
        // 为每种尺寸生成截图
        for (name, size) in macOSSizes {
            let scaledContent = content
                .frame(width: size.width/2, height: size.height/2) // 按比例缩小以适应视图
            
            let result = MagicImage.snapshot(scaledContent, title: "\(name)_\(MagicImage.getTimeString())")
            if result.contains("失败") {
                MagicMessageProvider.shared.error("生成 \(name) 截图失败")
                return
            }
        }
        
        MagicMessageProvider.shared.info("已生成macOS App Store所需的各种尺寸截图")
        #endif
    }
}

// MARK: - Preview

#if DEBUG
#Preview("MagicContainerPreview") {
    Text("Hello, World!")
        .padding()
        .inMagicContainer(containerWidth: 500)
}
#endif
