import MagicAlert
import SwiftUI

extension MagicContainer {
    /// 截图功能实现 (使用snapshot方法)
    func captureView() {
        #if os(macOS)
            let widthInt = Int(containerWidth)
            let heightInt = Int(containerHeight)
            let title = "MagicContainer_\(Date().compactDateTime)_\(widthInt)x\(heightInt)"
            do {
                try content.frame(width: containerWidth, height: containerHeight).snapshot(title: title, scale: 1)
                alert_success("截图已保存到下载文件夹")
            } catch {
                alert_error(error)
            } #endif
    }

    /// App Store截图功能实现 (生成多种分辨率的图片)
    func captureAppStoreView() {
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
                    alert_error(error)
                    return
                }
            }

            alert_info("已生成App Store所需的各种尺寸截图")
        #endif
    }

    /// macOS App Store截图功能实现 (生成多种分辨率的图片)
    func captureMacAppStoreView() {
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
                    alert_error("生成 \(name) 截图失败: \(error.localizedDescription)")
                    return
                }
            }

            alert_info("已生成macOS App Store所需的各种尺寸截图")
        #endif
    }

    /// Xcode 图标集生成功能实现
    func captureXcodeIcons() {
        #if os(macOS)
            Task {
                await generateXcodeIconSet()
                await generateXcodeIconSetLegacy()
            }
        #endif
    }

    /// 生成 Xcode 图标集
    @MainActor
    func generateXcodeIconSet() async {
        let tag = Date().compactDateTime

        guard let downloadsURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
            alert_error("无权访问下载文件夹")
            return
        }

        let folderName = "AppIcon-\(tag).appiconset"
        let folderPath = downloadsURL.appendingPathComponent(folderName, isDirectory: true)

        do {
            try FileManager.default.createDirectory(at: folderPath, withIntermediateDirectories: true)
        } catch {
            alert_error("创建目录失败：\(error)")
            return
        }

        // iOS 图标
        await generateIOSIcon(folderPath: folderPath, tag: tag, prefix: "")

        // macOS 图标
        await generateMacOSIcons(folderPath: folderPath, tag: tag, prefix: "", legacy: false)

        // Contents.json
        await generateContentsJson(folderPath: folderPath, tag: tag, prefix: "", includeIOS: true)

        alert_success("Xcode 图标集已生成到下载目录")
    }

    /// 生成 Xcode 图标集（适配低于 macOS 26 的系统）
    @MainActor
    func generateXcodeIconSetLegacy() async {
        let tag = Date().compactDateTime

        guard let downloadsURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
            alert_error("无权访问下载文件夹")
            return
        }

        let folderName = "AppIcons-\(tag)-legacy.appiconset"
        let folderPath = downloadsURL.appendingPathComponent(folderName, isDirectory: true)

        do {
            try FileManager.default.createDirectory(at: folderPath, withIntermediateDirectories: true)
        } catch {
            alert_error("创建目录失败：\(error)")
            return
        }

        // macOS 图标（缩小可视区域，避免在旧系统中显得过大）
        await generateMacOSIcons(folderPath: folderPath, tag: tag, prefix: "legacy-", legacy: true)

        // Contents.json（引用 legacy 前缀文件名）
        await generateContentsJson(folderPath: folderPath, tag: tag, prefix: "legacy-", includeIOS: false)

        alert_success("Xcode 图标集（legacy）已生成到下载目录")
    }

    /// 生成 iOS 图标 (1024x1024)
    @MainActor
    func generateIOSIcon(folderPath: URL, tag: String, prefix: String) async {
        let size = 1024
        let fileName = "\(tag)-\(prefix)ios-1024x1024.png"
        let saveTo = folderPath.appendingPathComponent(fileName)

        do {
            try content
                .frame(width: CGFloat(size), height: CGFloat(size))
                .snapshot(path: saveTo, scale: 1.0)
        } catch {
            alert_error("生成 iOS 图标失败: \(error)")
        }
    }

    /// 生成 macOS 图标 (1x 和 @2x)
    @MainActor
    func generateMacOSIcons(folderPath: URL, tag: String, prefix: String, legacy: Bool) async {
        let sizes = [16, 32, 128, 256, 512]
        // macOS Big Sur+ 图标圆角比例 (约 22.37%)
        let cornerRadiusRatio: CGFloat = 0.2237
        // 旧系统视觉安全区比例（缩小内容以避免显得过大）
        let legacyContentScale: CGFloat = 0.86

        for size in sizes {
            // 1x 版本
            let fileName = "\(tag)-\(prefix)macos-\(size)x\(size).png"
            let saveTo = folderPath.appendingPathComponent(fileName)
            let cornerRadius = CGFloat(size) * cornerRadiusRatio

            do {
                if legacy {
                    let innerSize = CGFloat(size) * legacyContentScale
                    let innerCorner = innerSize * cornerRadiusRatio
                    try content
                        .frame(width: innerSize, height: innerSize)
                        .clipShape(RoundedRectangle(cornerRadius: innerCorner, style: .continuous))
                        .frame(width: CGFloat(size), height: CGFloat(size))
                        .snapshot(path: saveTo, scale: 1.0)
                } else {
                    try content
                        .frame(width: CGFloat(size), height: CGFloat(size))
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                        .snapshot(path: saveTo, scale: 1.0)
                }
            } catch {
                alert_error("生成 \(fileName) 失败: \(error)")
            }

            // @2x 版本
            let doubleSize = size * 2
            let retinaFileName = "\(tag)-\(prefix)macos-\(size)x\(size)@2x.png"
            let retinaSaveTo = folderPath.appendingPathComponent(retinaFileName)
            let doubleCornerRadius = CGFloat(doubleSize) * cornerRadiusRatio

            do {
                if legacy {
                    let innerSize = CGFloat(doubleSize) * legacyContentScale
                    let innerCorner = innerSize * cornerRadiusRatio
                    try content
                        .frame(width: innerSize, height: innerSize)
                        .clipShape(RoundedRectangle(cornerRadius: innerCorner, style: .continuous))
                        .frame(width: CGFloat(doubleSize), height: CGFloat(doubleSize))
                        .snapshot(path: retinaSaveTo, scale: 1.0)
                } else {
                    try content
                        .frame(width: CGFloat(doubleSize), height: CGFloat(doubleSize))
                        .clipShape(RoundedRectangle(cornerRadius: doubleCornerRadius, style: .continuous))
                        .snapshot(path: retinaSaveTo, scale: 1.0)
                }
            } catch {
                alert_error("生成 \(retinaFileName) 失败: \(error)")
            }
        }
    }

    /// 生成 Contents.json 配置文件
    @MainActor
    func generateContentsJson(folderPath: URL, tag: String, prefix: String, includeIOS: Bool) async {
        var images: [[String: Any]] = []
        if includeIOS {
            images.append([
                "filename": "\(tag)-\(prefix)ios-1024x1024.png",
                "idiom": "universal",
                "platform": "ios",
                "size": "1024x1024"
            ])
        }
        let macSizes = [16, 32, 128, 256, 512]
        for s in macSizes {
            images.append([
                "filename": "\(tag)-\(prefix)macos-\(s)x\(s).png",
                "idiom": "mac",
                "scale": "1x",
                "size": "\(s)x\(s)"
            ])
        }
        for s in macSizes {
            images.append([
                "filename": "\(tag)-\(prefix)macos-\(s)x\(s)@2x.png",
                "idiom": "mac",
                "scale": "2x",
                "size": "\(s)x\(s)"
            ])
        }

        let contents: [String: Any] = [
            "images": images,
            "info": [
                "author": "xcode",
                "version": 1,
            ],
        ]

        do {
            let data = try JSONSerialization.data(withJSONObject: contents, options: .prettyPrinted)
            if let jsonString = String(data: data, encoding: .utf8) {
                try jsonString.write(
                    to: folderPath.appendingPathComponent("Contents.json"),
                    atomically: true,
                    encoding: .utf8
                )
            }
        } catch {
            alert_error("生成 Contents.json 失败: \(error)")
        }
    }
}

#if DEBUG
    #Preview("Xcode Icon Generator") {
        Image.makeCoffeeReelIcon()
            .inMagicContainer(CGSize(width: 1024, height: 1024), scale: 0.6)
    }

    #Preview("iMac 27 - 缩放") {
        Text("Hello, World!")
            .font(.system(size: 400))
            .magicCentered()
            .background(.indigo.opacity(0.3))
            .inMagicContainer(.iMac27, scale: 0.1)
    }
#endif
