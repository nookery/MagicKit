//
//  Thumbnail+Generator.swift
//  MagicKit
//
//  缩略图生成器
//

import Foundation
import OSLog
import SwiftUI

    /// 缩略图生成器
    /// 负责根据文件类型生成相应的缩略图
public struct ThumbnailGenerator {
    /// 要生成缩略图的 URL
    public let url: URL

    /// 目标尺寸
    public let size: CGSize

    /// 是否使用默认图标
    public let useDefaultIcon: Bool

    /// 是否输出详细日志
    public let verbose: Bool

    /// 调用原因（用于日志）
    public let reason: String

    /// 创建生成器
    /// - Parameters:
    ///   - url: 目标 URL
    ///   - size: 目标尺寸
    ///   - useDefaultIcon: 是否使用默认图标
    ///   - verbose: 是否输出详细日志
    ///   - reason: 调用原因
    public init(
        url: URL,
        size: CGSize,
        useDefaultIcon: Bool = true,
        verbose: Bool = false,
        reason: String = ""
    ) {
        self.url = url
        self.size = size
        self.useDefaultIcon = useDefaultIcon
        self.verbose = verbose
        self.reason = reason
    }

    /// 生成缩略图
    /// - Returns: 缩略图结果，如果无法生成则返回 nil
    public func generate() async throws -> ThumbnailResult? {
        if verbose {
            os_log("\(url.t)🐛 (\(reason)) 获取缩略图")
        }

        // 如果是网络 URL，返回下载图标
        if url.isNetworkURL {
            let image = Image.PlatformImage.fromSystemIcon(.iconICloudDownload)
            return ThumbnailResult(
                image: image,
                isSystemIcon: true,
                fileType: .unknown,
                source: .systemIcon,
                isCached: false
            )
        }

        // 如果是 iCloud 文件且未下载，返回下载图标
        if url.checkIsICloud(verbose: false) && url.isNotDownloaded {
            let image = Image.PlatformImage.fromSystemIcon(.iconICloudDownload)
            return ThumbnailResult(
                image: image,
                isSystemIcon: true,
                fileType: url.fileType,
                source: .systemIcon,
                isCached: false
            )
        }

        // 检查文件是否存在
        guard url.isFileExist else {
            throw URLError(.fileDoesNotExist)
        }

        // 根据文件类型生成缩略图
        if url.hasDirectoryPath {
            return try await folderThumbnail(size: size, verbose: verbose)
        }

        if url.isImage {
            return try await imageThumbnail(size: size, verbose: verbose)
        }

        if url.isAudio {
            let audioResult = try await audioThumbnail(size: size, verbose: verbose)
            return audioResult
        }

        if url.isVideo {
            return try await videoThumbnail(size: size, verbose: verbose)
        }

        // 如果无法识别类型，返回默认文档图标
        if useDefaultIcon,
           let image = Image.PlatformImage.fromSystemIcon(url.icon) {
            if verbose { os_log("\(url.t)<\(url.title)>使用默认系统图标") }
            return ThumbnailResult(
                image: image,
                isSystemIcon: true,
                fileType: .document,
                source: .systemIcon,
                isCached: false
            )
        }

        if verbose { os_log("\(url.t)无法识别文件类型，返回 nil") }

        return nil
    }
}

// MARK: - File Type Detection

private extension URL {
    /// 根据 URL 路径或扩展名推断文件类型
    var fileType: FileType {
        if hasDirectoryPath {
            return .folder
        }
        if isImage {
            return .image
        }
        if isVideo {
            return .video
        }
        if isAudio {
            return .audio
        }
        // 可以根据扩展名添加更多文档类型的判断
        let ext = pathExtension.lowercased()
        if ["pdf", "doc", "docx", "txt", "rtf", "pages"].contains(ext) {
            return .document
        }
        return .unknown
    }
}
