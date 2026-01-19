import Foundation
import MagicAlert
import SwiftUI
#if os(macOS)
    import AppKit
#endif

/// 视图容器，提供多种实用功能
struct MagicContainer<Content: View>: View {
    // MARK: - Properties

    private let content: Content
    private let containerHeight: CGFloat
    private let containerWidth: CGFloat
    private let scale: CGFloat
    private let toolBarHeight: CGFloat = 100
    private let bottomPadding: CGFloat = 10

    @Environment(\.colorScheme) private var systemColorScheme
    @State private var isDarkMode: Bool = false

    // MARK: - Initialization

    /// 创建容器
    /// - Parameters:
    ///   - containerSize: 容器尺寸，默认为 500x750
    ///   - scale: 缩放比例，默认为 1.0
    ///   - content: 要预览的内容视图
    public init(
        _ containerSize: CGSize = CGSize(width: 500, height: 750),
        scale: CGFloat = 1.0,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.containerHeight = containerSize.height
        self.containerWidth = containerSize.width
        self.scale = scale
    }

    // MARK: - Body

    public var body: some View {
        // MARK: Content Layer

        VStack(spacing: 0) {
            // MARK: Toolbar

            MagicContainerToolbar(
                isDarkMode: $isDarkMode,
                captureAction: captureView,
                appStoreCaptureAction: captureAppStoreView,
                macAppStoreCaptureAction: captureMacAppStoreView,
                containerSize: CGSize(width: containerWidth, height: containerHeight),
                scale: scale
            )
            .frame(height: toolBarHeight)
            .frame(maxWidth: .infinity)

            // MARK: Content Area

            content.frame(width: containerWidth, height: containerHeight)
                .dashedBorder()
                .scaleEffect(scale)
                .frame(width: containerWidth * scale, height: containerHeight * scale)

            Spacer(minLength: bottomPadding)
        }
        .background(.background)
        .environment(\.colorScheme, isDarkMode ? .dark : .light)
        .frame(width: containerWidth * scale, height: toolBarHeight + bottomPadding + containerHeight * scale)
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
            let widthInt = Int(containerWidth)
            let heightInt = Int(containerHeight)
            let title = "MagicContainer_\(Date().compactDateTime)_\(widthInt)x\(heightInt)"
            do {
                try content.frame(width: containerWidth, height: containerHeight).snapshot(title: title, scale: 2.0)
                MagicMessageProvider.shared.success("截图已保存到下载文件夹")
            } catch {
                MagicMessageProvider.shared.error(error)
            } #endif
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
                ("iPhone_4.7inch", CGSize(width: 750, height: 1334)), // iPhone SE 2nd gen, etc.
            ]

            // App Store要求的iPad截图尺寸
            let iPadSizes: [(String, CGSize)] = [
                ("iPad_12.9inch", CGSize(width: 2048, height: 2732)), // iPad Pro 12.9"
                ("iPad_11inch", CGSize(width: 1668, height: 2388)), // iPad Pro 11"
                ("iPad_10.5inch", CGSize(width: 1668, height: 2224)), // iPad Pro 10.5"
            ]

            // 为每种尺寸生成截图
            for (name, size) in iPhoneSizes + iPadSizes {
                let scaledContent = content
                    .frame(width: size.width, height: size.height)

                let title = "\(name)_\(Date().compactDateTime)_\(Int(size.width))x\(Int(size.height))"
                do {
                    try scaledContent.snapshot(title: title, scale: 1.0)
                } catch {
                    MagicMessageProvider.shared.error(error)
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
                ("macOS_2880x1800", CGSize(width: 2880, height: 1800)),
            ]

            // 为每种尺寸生成截图
            for (name, size) in macOSSizes {
                let scaledContent = content
                    .frame(width: size.width, height: size.height)

                let title = "\(name)_\(Date().compactDateTime)_\(Int(size.width))x\(Int(size.height))"
                do {
                    try scaledContent.snapshot(title: title, scale: 1.0)
                } catch {
                    MagicMessageProvider.shared.error("生成 \(name) 截图失败: \(error.localizedDescription)")
                    return
                }
            }

            MagicMessageProvider.shared.info("已生成macOS App Store所需的各种尺寸截图")
        #endif
    }
}

// MARK: - Preview

#if DEBUG
    #Preview("iPhone") {
        MagicContainerPreview.iPhonePreview
    }
#endif
