import Foundation
import OSLog
import SwiftUI
import Compression

import Foundation
import SwiftUI

import UniformTypeIdentifiers

public extension URL {
    /// 返回 URL 对应的默认系统图标图片
    var defaultImage: Image {
        Image(systemName: systemIcon)
    }
    
    /// 是否是音频文件
    var isAudio: Bool {
        if let type = try? resourceValues(forKeys: [.contentTypeKey]).contentType {
            return type.conforms(to: .audio)
        }
        return audioExtensions.contains(pathExtension.lowercased())
    }

    /// 是否是视频文件
    var isVideo: Bool {
        if let type = try? resourceValues(forKeys: [.contentTypeKey]).contentType {
            return type.conforms(to: .audiovisualContent)
        }
        return videoExtensions.contains(pathExtension.lowercased())
    }

    /// 是否是图片文件
    var isImage: Bool {
        if let type = try? resourceValues(forKeys: [.contentTypeKey]).contentType {
            return type.conforms(to: .image)
        }
        return imageExtensions.contains(pathExtension.lowercased())
    }
    
    /// 是否是文档文件
    var isDocument: Bool {
        if let type = try? resourceValues(forKeys: [.contentTypeKey]).contentType {
            return type.conforms(to: .data)
        }
        return documentExtensions.contains(pathExtension.lowercased())
    }
    
    /// 是否是电子书
    var isEbook: Bool {
        if let type = try? resourceValues(forKeys: [.contentTypeKey]).contentType {
            return type.conforms(to: .epub) || type.conforms(to: .pdf)
        }
        return ebookExtensions.contains(pathExtension.lowercased())
    }
    
    /// 是否是字体文件
    var isFont: Bool {
        if let type = try? resourceValues(forKeys: [.contentTypeKey]).contentType {
            return type.conforms(to: .font)
        }
        return fontExtensions.contains(pathExtension.lowercased())
    }
    
    /// 是否是代码文件
    var isCode: Bool {
        codeExtensions.contains(pathExtension.lowercased())
    }

    /// 是否是文件夹
    var isDirectory: Bool {
        (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }

    /// 是否是媒体文件（音频或视频）
    var isMedia: Bool {
        isAudio || isVideo
    }

    /// 是否是本地文件
    var isLocalFile: Bool {
        isFileURL && FileManager.default.fileExists(atPath: path)
    }

    /// 是否是网络 URL
    var isNetworkURL: Bool {
        scheme == "http" || scheme == "https"
    }

    /// 是否是 PDF 文件
    var isPDF: Bool {
        if let type = try? resourceValues(forKeys: [.contentTypeKey]).contentType {
            return type.conforms(to: .pdf)
        }
        return pathExtension.lowercased() == "pdf"
    }
    
    /// 是否是文本文件
    var isText: Bool {
        if let type = try? resourceValues(forKeys: [.contentTypeKey]).contentType {
            return type.conforms(to: .text)
        }
        return textExtensions.contains(pathExtension.lowercased())
    }
    
    /// 是否是压缩文件
    var isArchive: Bool {
        if let type = try? resourceValues(forKeys: [.contentTypeKey]).contentType {
            return type.conforms(to: .archive)
        }
        return archiveExtensions.contains(pathExtension.lowercased())
    }

    /// 返回 URL 对应的文件类型标签视图
    var label: Label<Text, Image> {
        if isAudio {
            return Label("Audio", systemImage: icon)
        } else if isVideo {
            return Label("Video", systemImage: icon)
        } else if isImage {
            return Label("Image", systemImage: icon)
        } else if isDirectory {
            return Label("Directory", systemImage: icon)
        } else if isPDF {
            return Label("PDF", systemImage: icon)
        } else if isText {
            return Label("Text", systemImage: icon)
        } else if isArchive {
            return Label("Archive", systemImage: icon)
        } else if isDocument {
            return Label("Document", systemImage: icon)
        } else if isEbook {
            return Label("Ebook", systemImage: icon)
        } else if isFont {
            return Label("Font", systemImage: icon)
        } else if isCode {
            return Label("Code", systemImage: icon)
        } else {
            return Label("Other", systemImage: icon)
        }
    }

    /// 返回 URL 对应的文件类型图标名称
    var icon: String {
        if isAudio {
            return "music.note"
        } else if isVideo {
            return "film"
        } else if isImage {
            return "photo"
        } else if isDirectory {
            return "folder"
        } else if isPDF {
            return "doc.text"
        } else if isText {
            return "doc.text.fill"
        } else if isArchive {
            return "doc.zipper"
        } else if isDocument {
            return "doc.richtext"
        } else if isEbook {
            return "book"
        } else if isFont {
            return "textformat"
        } else if isCode {
            return "chevron.left.forwardslash.chevron.right"
        } else if isNetworkURL {
            return "globe"
        } else {
            return "doc"
        }
    }
    
    var systemIcon: String { icon }
}

// MARK: - Supported Extensions

private extension URL {
    /// 支持的音频文件扩展名
    var audioExtensions: Set<String> {
        [
            "mp3", "m4a", "aac", "wav", "aiff", "wma",
            "ogg", "oga", "opus", "flac", "alac", "mid",
            "midi", "ac3", "dsf", "dff", "ape", "wv"
        ]
    }

    /// 支持的视频文件扩展名
    var videoExtensions: Set<String> {
        [
            "mp4", "m4v", "mov", "avi", "wmv", "flv",
            "mkv", "webm", "3gp", "mpeg", "mpg", "ts",
            "mts", "m2ts", "vob", "ogv", "rm", "rmvb",
            "asf", "divx", "f4v"
        ]
    }

    /// 支持的图片文件扩展名
    var imageExtensions: Set<String> {
        [
            "jpg", "jpeg", "png", "gif", "bmp", "tiff",
            "webp", "heic", "heif", "raw", "svg", "ico",
            "tga", "psd", "ai", "eps", "cr2", "nef",
            "arw", "dng", "orf", "rw2"
        ]
    }

    /// 支持的文本文件扩展名
    var textExtensions: Set<String> {
        [
            "txt", "rtf", "md", "json", "xml", "yml",
            "yaml", "csv", "log", "ini", "conf", "cfg",
            "properties", "env", "toml", "tex"
        ]
    }
    
    /// 支持的压缩文件扩展名
    var archiveExtensions: Set<String> {
        [
            "zip", "rar", "7z", "tar", "gz", "bz2",
            "xz", "tgz", "tbz", "lz", "lzma", "lzo",
            "z", "ace", "cab", "iso", "dmg"
        ]
    }
    
    /// 支持的文档文件扩展名
    var documentExtensions: Set<String> {
        [
            "doc", "docx", "xls", "xlsx", "ppt", "pptx",
            "odt", "ods", "odp", "pages", "numbers",
            "keynote", "key", "wpd", "wps", "rtfd"
        ]
    }
    
    /// 支持的电子书扩展名
    var ebookExtensions: Set<String> {
        [
            "epub", "mobi", "azw", "azw3", "fb2",
            "lit", "lrf", "pdb", "pdf", "djvu",
            "cbz", "cbr", "cbt", "cb7"
        ]
    }
    
    /// 支持的字体文件扩展名
    var fontExtensions: Set<String> {
        [
            "ttf", "otf", "woff", "woff2", "eot",
            "pfm", "pfb", "sfd", "bdf", "psf"
        ]
    }
    
    /// 支持的代码文件扩展名
    var codeExtensions: Set<String> {
        [
            "swift", "java", "kt", "cpp", "c", "h",
            "hpp", "cs", "py", "rb", "php", "js",
            "ts", "html", "css", "scss", "less",
            "sql", "go", "rs", "dart", "lua"
        ]
    }
}

public extension URL {
    /// 打开URL：如果是网络链接则在浏览器打开，如果是本地文件则在访达中显示
    func open() {
        if isNetworkURL {
            openInBrowser()
        } else {
            openInFinder()
        }
    }

    /// 在浏览器中打开URL
    func openInBrowser() {
        #if os(iOS)
            UIApplication.shared.open(self)
        #elseif os(macOS)
            NSWorkspace.shared.open(self)
        #endif
    }

    /// 在访达中显示文件或文件夹
    func openInFinder() {
        #if os(macOS)
            showInFinder()
        #else
            openFolder()
        #endif
    }

    #if os(macOS)
        /// 在访达中显示并选中文件
        func showInFinder() {
            NSWorkspace.shared.activateFileViewerSelecting([self])
        }

       
    #endif

    /// 打开包含该文件的文件夹
    func openFolder() {
        let folderURL = self.hasDirectoryPath ? self : self.deletingLastPathComponent()
        #if os(iOS)
            UIApplication.shared.open(folderURL)
        #elseif os(macOS)
            NSWorkspace.shared.open(folderURL)
        #endif
    }
    
    /// 删除指定 URL 对应的文件或目录。
    ///
    /// 此方法从文件系统中删除文件或目录。如果 URL 指向一个目录，
    /// 其所有内容也将被删除。
    ///
    /// - Throws: 如果删除失败或文件没有足够的权限时抛出错误。
    /// - Note: 此操作无法撤消。
    func delete() throws {
        guard FileManager.default.fileExists(atPath: self.path) else {
            return
        }
        try FileManager.default.removeItem(at: self)
    }

    /// 递归返回目录及其子目录中的所有文件。
    ///
    /// - Returns: 包含目录树中所有文件 URL 的数组。
    /// - Note: 此方法会自动过滤掉 .DS_Store 文件。
    func flatten() -> [URL] {
        getAllFilesInDirectory()
    }

    /// 递归返回目录及其子目录中的所有文件。
    ///
    /// - Returns: 包含目录树中所有文件 URL 的数组。
    /// - Note: 此方法会自动过滤掉 .DS_Store 文件。
    /// - Important: 如果无法访问目录，此方法会记录错误。
    func getAllFilesInDirectory() -> [URL] {
        let fileManager = FileManager.default
        var fileURLs: [URL] = []

        do {
            let urls = try fileManager.contentsOfDirectory(at: self, includingPropertiesForKeys: nil, options: [])

            for url in urls {
                if url.hasDirectoryPath {
                    fileURLs += url.getAllFilesInDirectory()
                } else {
                    fileURLs.append(url)
                }
            }
        } catch {
            os_log(.error, "读取目录时发生错误: \(error.localizedDescription)")
        }

        return fileURLs.filter { $0.lastPathComponent != ".DS_Store" }
    }

    /// 返回当前目录的直接子项（文件和目录）。
    ///
    /// - Returns: 按名称排序的直接子项 URL 数组。
    /// - Note: 此方法会自动过滤掉 .DS_Store 文件。
    func getChildren() -> [URL] {
        let fileManager = FileManager.default
        var fileURLs: [URL] = []

        do {
            let urls = try fileManager.contentsOfDirectory(at: self, includingPropertiesForKeys: nil, options: [])
            fileURLs = urls.sorted { $0.lastPathComponent.localizedStandardCompare($1.lastPathComponent) == .orderedAscending }
        } catch {
            os_log(.error, "读取目录时发生错误: \(error)")
        }

        return fileURLs.filter { $0.lastPathComponent != ".DS_Store" }
    }

    /// 返回当前目录的直接文件子项（不包括目录）。
    ///
    /// - Returns: 按名称排序的直接文件子项 URL 数组。
    /// - Note: 此方法会自动过滤掉 .DS_Store 文件。
    func getFileChildren() -> [URL] {
        let fileManager = FileManager.default
        var fileURLs: [URL] = []

        do {
            let urls = try fileManager.contentsOfDirectory(at: self, includingPropertiesForKeys: nil, options: [])
            fileURLs = urls.filter { !$0.hasDirectoryPath }
        } catch {
            os_log(.error, "读取目录时发生错误: \(error)")
        }

        return fileURLs
            .filter { $0.lastPathComponent != ".DS_Store" }
            .sorted { $0.lastPathComponent < $1.lastPathComponent }
    }

    /// 返回父目录中的下一个文件。
    ///
    /// - Returns: 下一个文件的 URL，如果是最后一个文件则返回 `nil`。
    /// - Note: 文件按名称字母顺序排序。
    func getNextFile() -> URL? {
        let parent = deletingLastPathComponent()
        let files = parent.getChildren()
        guard let index = files.firstIndex(of: self) else {
            return nil
        }

        return index < files.count - 1 ? files[index + 1] : nil
    }

    /// 返回父目录中的上一个文件。
    ///
    /// - Returns: 上一个文件的 URL，如果是第一个文件则返回 `nil`。
    /// - Note: 文件按名称字母顺序排序。
    func getPrevFile() -> URL? {
        let parent = deletingLastPathComponent()
        let files = parent.getChildren()
        guard let index = files.firstIndex(of: self) else {
            return nil
        }

        return index > 0 ? files[index - 1] : nil
    }

    /// 计算文件或目录的大小（以字节为单位）。
    ///
    /// 对于目录，此方法会递归计算所有包含文件的总大小。
    ///
    /// - Returns: 以 Int64 表示的字节大小。
    /// - Note: 如果无法确定大小，则返回 0。
    func getSize() -> Int64 {
        // 如果是文件夹，计算所有子项的大小总和
        if hasDirectoryPath {
            return getAllFilesInDirectory()
                .reduce(Int64(0)) { $0 + $1.getSize() }
        }

        // 如果是文件，返回文件大小
        let attributes = try? resourceValues(forKeys: [.fileSizeKey])
        return Int64(attributes?.fileSize ?? 0)
    }

    /// 返回文件或目录大小的人类可读格式。
    ///
    /// 大小会自动转换为最适合的单位（B、KB、MB、GB 或 TB）。
    ///
    /// - Returns: 表示大小的格式化字符串（例如："1.5 MB"）。
    func getSizeReadable() -> String {
        let size = Double(getSize())
        let units = ["B", "KB", "MB", "GB", "TB"]
        var index = 0
        var convertedSize = size

        while convertedSize >= 1024 && index < units.count - 1 {
            convertedSize /= 1024
            index += 1
        }

        return String(format: "%.1f %@", convertedSize, units[index])
    }

    /// 检查 URL 是否指向现有目录。
    var isDirExist: Bool {
        var isDir: ObjCBool = true
        return FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
    }

    /// 检查 URL 是否指向现有文件。
    var isFileExist: Bool {
        FileManager.default.fileExists(atPath: path)
    }

    var isNotFileExist: Bool {
        !isFileExist
    }

    var isNotDirExist: Bool {
        !isDirExist
    }

    /// 删除当前文件或目录的父文件夹。
    ///
    /// - Throws: 如果删除失败或文件夹没有足够的权限时抛出错误。
    /// - Important: 此操作无法撤消，并且会删除父文件夹的所有内容。
    func removeParentFolder() throws {
        try FileManager.default.removeItem(at: deletingLastPathComponent())
    }

    /// 根据条件删除当前文件或目录的父文件夹。
    ///
    /// - Parameter condition: 决定是否应删除父文件夹的布尔值。
    /// - Note: 此方法会静默忽略删除过程中发生的任何错误。
    func removeParentFolderWhen(_ condition: Bool) {
        if condition {
            try? removeParentFolder()
        }
    }

    /// 如果 URL 对应的目录或文件不存在则创建它，并返回 URL。
    ///
    /// - 对于目录：创建目录及任何必要的中间目录。
    /// - 对于文件：创建空文件及任何必要的父目录。
    ///
    /// - Returns: 当前 URL（self）
    /// - Throws: 如果创建失败则抛出错误
    @discardableResult
    func createIfNotExist() throws -> URL {
        // 处理父目录
        let parentDir = deletingLastPathComponent()
        if parentDir.isNotDirExist {
            try FileManager.default.createDirectory(at: parentDir, withIntermediateDirectories: true)
        }
        
        // 处理当前路径
        if hasDirectoryPath {
            if isNotDirExist {
                try FileManager.default.createDirectory(at: self, withIntermediateDirectories: true)
            }
        } else {
            if isNotFileExist {
                do {
                    try Data().write(to: self)
                } catch {
                    throw error
                }
            }
        }
        
        return self
    }
}
