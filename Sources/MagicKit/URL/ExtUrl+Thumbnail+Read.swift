import AVFoundation
import AVKit
import Foundation
import OSLog
import SwiftUI

extension URL {
    public typealias ThumbnailResult = (image: Image.PlatformImage?, isSystemIcon: Bool)

    /// 从音频文件的元数据中获取封面图片
    /// - Parameters:
    ///   - size: 可选参数，指定返回图片的大小。如果为 nil，则返回原始大小
    ///   - verbose: 是否输出详细日志
    /// - Returns: 如果找到封面则返回 SwiftUI.Image，否则返回 nil
    public func coverFromMetadata(
        size: CGSize? = nil,
        verbose: Bool = false
    ) async throws -> Image? {
        if let platformImage = try await getPlatformCoverFromMetadata(verbose: verbose) {
            if let size = size {
                return platformImage.resize(to: size).toSwiftUIImage()
            }
            return platformImage.toSwiftUIImage()
        }
        return nil
    }

    /// 从音频文件的元数据中获取封面图片（原生图片格式）
    /// - Parameter verbose: 是否输出详细日志
    /// - Returns: 如果找到封面则返回平台原生图片格式，否则返回 nil
    public func getPlatformCoverFromMetadata(verbose: Bool = false) async throws -> Image.PlatformImage? {
        let printArtworkKeys = true

        if verbose {
            os_log("\(self.t)<\(self.title)>从音频文件的元数据中获取封面图片")
        }

        let asset = AVURLAsset(url: self)

        let artworkKeys = [
            AVMetadataKey.commonKeyArtwork,
            AVMetadataKey.id3MetadataKeyAttachedPicture,
            AVMetadataKey.iTunesMetadataKeyCoverArt,
        ]

        do {
            let commonMetadata = try await asset.load(.commonMetadata)

            if artworkKeys.isEmpty {
                if verbose { os_log("\(self.t)<\(self.title)>音频文件的元数据没有任何键值对") }
                return nil
            }

            for key in artworkKeys {
                if verbose && printArtworkKeys {
                    os_log("\(self.t)<\(self.title)>尝试从音频文件的元数据中获取封面图片: \(key.rawValue)")
                }

                let artworkItems = AVMetadataItem.metadataItems(
                    from: commonMetadata,
                    withKey: key,
                    keySpace: AVMetadataKeySpace.common
                )

                if let artworkItem = artworkItems.first {
                    do {
                        if let artworkData = try await artworkItem.load(.value) as? Data {
                            if let image = Image.PlatformImage.fromCacheData(artworkData) {
                                if verbose { os_log("\(self.t)<\(self.title)>从音频文件的元数据中获取封面图片: \(key.rawValue) 成功") }
                                return image
                            }
                        } else if let artworkImage = try await artworkItem.load(.value) as? Image.PlatformImage {
                            if verbose { os_log("\(self.t)<\(self.title)>从音频文件的元数据中获取封面图片: \(key.rawValue) 成功") }
                            return artworkImage
                        }
                    } catch {
                        os_log(.error, "Failed to load artwork for key \(key.rawValue): \(error.localizedDescription)")
                        continue
                    }
                }
            }

            if verbose { os_log("\(self.t)<\(self.title)>音频文件的元数据中没有封面图片") }

            return nil
        } catch {
            os_log(.error, "\(self.t)<\(self.title)>无法从音频文件的元数据中获取封面图片: \(error.localizedDescription)")

            throw error
        }
    }

    /// 获取文件的缩略图
    /// - Parameters:
    ///   - size: 缩略图的目标大小
    /// - Returns: 生成的缩略图，如果无法生成则返回 nil
    public func thumbnail(
        size: CGSize = CGSize(width: 120, height: 120),
        useDefaultIcon: Bool = true,
        verbose: Bool,
        reason: String
    ) async throws -> Image? {
        let canUseCache = isDownloaded || isNotiCloud
        
        // 检查缓存
        if canUseCache, let cachedImage = ThumbnailCache.shared.fetch(for: self, size: size) {
            if verbose {
                os_log("\(self.t)🐛 (\(reason)) 从缓存中获取缩略图")
            }
            return cachedImage.toSwiftUIImage()
        }

        do {
            // 生成缩略图
            if let result = try await platformThumbnail(size: size, useDefaultIcon: useDefaultIcon, verbose: verbose, reason: reason),
               let image = result.image {
                // 只缓存非系统图标的缩略图
                if !result.isSystemIcon {
                    let cache = ThumbnailCache.shared
                    cache.verbose = verbose
                    cache.save(image, for: self, size: size)
                }

                return image.toSwiftUIImage()
            }
            
            return nil
        } catch {
            os_log(.error, "\(self.t)<\(self.title)>获取缩略图失败: \(error.localizedDescription)")
            throw error
        }
    }

    /// 获取文件的缩略图（原生图片格式）
    /// - Parameters:
    ///   - size: 缩略图的目标大小
    /// - Returns: 生成的缩略图，如果无法生成则返回 nil
    public func platformThumbnail(
        size: CGSize = CGSize(width: 120, height: 120),
        useDefaultIcon: Bool = true,
        verbose: Bool,
        reason: String
    ) async throws -> ThumbnailResult? {
        if verbose {
            os_log("\(self.t)🐛 (\(reason)) 获取缩略图")
        }

        // 如果是网络 URL，根据文件类型返回对应图标
        if isNetworkURL {
            return (Image.PlatformImage.fromSystemIcon(.iconICloudDownload), true)
        }

        // 如果是 iCloud 文件且未下载，返回下载图标
        if checkIsICloud(verbose: false) && isNotDownloaded {
            return (Image.PlatformImage.fromSystemIcon(.iconICloudDownload), true)
        }

        // 检查文件是否存在
        guard self.isFileExist else {
            throw URLError(.fileDoesNotExist)
        }

        if hasDirectoryPath {
            if verbose { os_log("\(self.t)<\(self.title)>格式是目录，获取目录缩略图") }
            return try await platformFolderThumbnail(size: size, verbose: verbose)
        }

        if isImage {
            if verbose { os_log("\(self.t)<\(self.title)>格式是图片，获取图片缩略图") }
            return try await platformImageThumbnail(size: size, verbose: verbose)
        }

        if isAudio {
            if verbose { os_log("\(self.t)<\(self.title)>格式是音频，获取音频缩略图") }
            let audioFileThumbnail = try await platformAudioThumbnail(size: size, verbose: verbose)
            if let audioFileThumbnail = audioFileThumbnail {
                return audioFileThumbnail
            } else {
                return nil
            }
        }

        if isVideo {
            if verbose { os_log("\(self.t)<\(self.title)>格式是视频，获取视频缩略图") }
            return try await platformVideoThumbnail(size: size, verbose: verbose)
        }

        // 如果无法识别类型，返回默认文档图标
        if useDefaultIcon, let image = Image.PlatformImage.fromSystemIcon(icon) {
            if verbose { os_log("\(self.t)<\(self.title)>使用默认系统图标") }
            return (image, true)
        }

        if verbose { os_log("\(self.t)无法识别文件类型，返回 nil") }

        return nil
    }

    /// 获取缩略图缓存目录
    /// - Returns: 缩略图缓存目录的 URL
    public static func thumbnailCacheDirectory() -> URL {
        return ThumbnailCache.shared.getCacheDirectory()
    }

    // MARK: - Private Platform Image Methods

    private func platformFolderThumbnail(size: CGSize, verbose: Bool) async throws -> ThumbnailResult {
        return (Image.PlatformImage.folderIcon(size: size), true)
    }

    private func platformImageThumbnail(size: CGSize, verbose: Bool) async throws -> ThumbnailResult {
        guard let image = Image.PlatformImage.fromFile(self) else {
            throw URLError(.cannotDecodeContentData)
        }
        return (image.resize(to: size, quality: .high), false)
    }

    private func platformVideoThumbnail(size: CGSize, verbose: Bool) async throws -> ThumbnailResult {
        let asset = AVAsset(url: self)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.maximumSize = size

        do {
            let cgImage = try await imageGenerator.image(at: .zero).image
            return (Image.PlatformImage.fromCGImage(cgImage, size: size), false)
        } catch {
            throw error
        }
    }

    private func platformAudioThumbnail(size: CGSize, verbose: Bool) async throws -> ThumbnailResult? {
        // 尝试从音频元数据中获取封面
        if verbose { os_log("\(self.t)<\(self.title)>尝试从音频元数据中获取封面") }

        do {
            if let coverImage = try await getPlatformCoverFromMetadata(verbose: verbose) {
                if verbose { os_log("\(self.t)<\(self.title)>从音频元数据中获取封面 成功") }
                return (coverImage.resize(to: size), false)
            }
            
            if verbose { os_log("\(self.t)<\(self.title)>音频元数据中没有封面图片") }
            
            return nil
        } catch {
            os_log(.error, "\(self.t)<\(self.title)>从音频元数据中获取封面失败: \(error.localizedDescription)")
            throw error
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    ThumbnailPreview()
}
#endif
