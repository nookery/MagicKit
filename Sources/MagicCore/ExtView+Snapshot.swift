import SwiftUI
import Foundation
import UniformTypeIdentifiers

// MARK: - Snapshot Extensions
public extension View {
    /// 获取视图的宽度
    /// 
    /// - Returns: 视图的宽度（像素）
    /// - Note: 此方法必须在主线程上调用
    @MainActor func getWidth() -> Int {
        Image.makeCGImage(from: self).width
    }

    /// 获取视图的高度
    /// 
    /// - Returns: 视图的高度（像素）
    /// - Note: 此方法必须在主线程上调用
    @MainActor func getHeight() -> Int {
        Image.makeCGImage(from: self).height
    }
    
    /// 将视图转换为 SwiftUI Image 对象
    /// 
    /// - Returns: 转换后的 SwiftUI Image 对象
    /// - Note: 此方法必须在主线程上调用
    ///        返回的 Image 对象比例因子为 1，标签文本为"目标图像"
    @MainActor func toImage() -> Image {
        Image.fromView(self)
    }
    
    /// 将视图转换为 CGImage
    /// 
    /// - Returns: 转换后的 CGImage 对象
    /// - Note: 此方法必须在主线程上调用
    ///        如果转换失败，会创建一个1x1的透明图片作为fallback
    @MainActor func toCGImage() -> CGImage {
        Image.makeCGImage(from: self)
    }
    
    /// 将视图保存为 PNG 图像文件
    /// 
    /// - Parameters:
    ///   - path: 保存文件的目标 URL，如果为 nil 则保存到下载目录
    ///   - title: 文件名，如果为 nil 则使用时间戳和尺寸信息命名
    /// - Returns: 操作结果的描述信息，成功时返回"已存储到下载文件夹"，失败时返回错误信息
    /// - Note: 此方法必须在主线程上调用
    @MainActor func snapshot(path: URL? = nil, title: String? = nil) -> String {
        guard let downloadsURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
            return "Failed to access downloads folder."
        }

        let width = getWidth()
        let height = getHeight()
        let fileName = title != nil ? "\(title!).png" : "\(Image.getTimeString())-\(width)x\(height).png"
        let defaultPath = downloadsURL.appendingPathComponent(fileName)
        let finalPath = path == nil ? defaultPath : path!

        guard let destination = CGImageDestinationCreateWithURL(finalPath as CFURL, UTType.png.identifier as CFString, 1, nil) else {
            return "创建图像目标失败，请确保应用有下载目录的写入权限"
        }

        CGImageDestinationAddImage(destination, toCGImage(), nil)

        guard CGImageDestinationFinalize(destination) else {
            return "图像保存失败"
        }

        return "已存储到下载文件夹"
    }
}
