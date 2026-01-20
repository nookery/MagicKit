import Combine
import os
import SwiftUI
import UniformTypeIdentifiers

/// 一个用于展示文件缩略图的头像视图组件
///
/// `AvatarView` 是一个多功能的视图组件，专门用于展示文件的缩略图和状态。
/// 它支持多种文件类型，包括图片、视频、音频等，并能自动处理不同的显示状态。
///
/// # 功能特性
/// - 自动生成文件缩略图
/// - 支持多种文件类型
/// - 实时显示下载进度
/// - 错误状态可视化
/// - 可自定义外观
///
/// # 示例代码
/// ```swift
/// // 基础用法
/// AvatarView(url: fileURL)
///
/// // 自定义形状
/// AvatarView(url: fileURL)
///     .magicShape(.roundedRectangle(cornerRadius: 8))
///
/// // 下载进度控制
/// @State var progress: Double = 0
/// AvatarView(url: fileURL)
///     .magicDownloadProgress($progress)
/// ```
public struct AvatarView: View, SuperLog {
    // MARK: - Properties

    /// 表情符号标识符
    public static let emoji = "🚉"

    /// 视图状态管理器，管理缩略图、加载状态和错误状态
    @StateObject private var state = ViewState()

    /// 全局下载进度订阅
    @State private var progressCancellable: AnyCancellable? = nil

    /// 文件的URL
    let url: URL

    /// 日志回调，用于让调用者接收本视图内部的日志信息
    var onLog: ((String, MagicLogEntry.Level) -> Void)?

    /// 是否启用详细日志输出
    let verbose: Bool

    /// 视图的形状样式
    var shape: AvatarViewShape = .circle

    /// 是否监控下载进度（仅对iCloud文件有效）
    var monitorDownload: Bool = true

    /// 下载进度绑定，用于外部控制下载进度显示
    var progressBinding: Binding<Double>?

    /// 视图尺寸
    var size: CGSize = CGSize(width: 40, height: 40)

    /// 视图背景色
    var backgroundColor: Color = .blue.opacity(0.1)

    /// 是否显示右键菜单
    var showContextMenu: Bool = true

    /// 控制图片选择器是否显示
    @State private var isImagePickerPresented = false

    /// 魔法日志记录器
    private let logger = MagicLogger()

    // MARK: - Computed Properties

    /// 当前的下载进度
    private var downloadProgress: Double {
        progressBinding?.wrappedValue ?? state.autoDownloadProgress
    }

    /// 是否正在下载
    private var isDownloading: Bool {
        // 检查手动控制的进度
        if let binding = progressBinding {
            if binding.wrappedValue <= 1 {
                return true
            }
        }

        // 检查自动监控的进度
        if downloadProgress > 0 && downloadProgress <= 1 {
            return true
        }

        return false
    }

    // MARK: - Initialization

    /// 创建一个新的头像视图
    /// - Parameters:
    ///   - url: 要显示的文件URL
    ///   - size: 视图的尺寸，默认为 40x40
    public init(url: URL, size: CGSize = CGSize(width: 40, height: 40), verbose: Bool = false) {
        self.url = url
        self.size = size
        self.verbose = verbose

        // 在初始化时进行基本的 URL 检查
        if url.isFileURL {
            // 检查本地文件是否存在
            if url.isNotFileExist {
                if self.verbose {
                    os_log("\(Self.t)文件不存在: \(url.path)")
                }
                _state = StateObject(wrappedValue: ViewState())
                state.setError(ViewError.fileNotFound)
            }
        } else {
            // 检查 URL 格式
            guard url.isNetworkURL else {
                os_log(.error, "\(Self.t)无效的 URL: \(url)")
                _state = StateObject(wrappedValue: ViewState())
                state.setError(ViewError.invalidURL)
                return
            }
        }
    }

    /// 加载延迟时间（毫秒），用于防止快速滚动时触发过多缩略图加载
    var loadDelay: UInt64 = 150
    
    // MARK: - Body

    public var body: some View {
        Group {
            if isDownloading && downloadProgress < 1 {
                DownloadProgressView(progress: downloadProgress)
            } else if let thumbnail = state.thumbnail {
                ThumbnailImageView(image: thumbnail)
            } else if let error = state.error {
                ErrorIndicatorView(error: error)
            } else if state.isLoading {
                ProgressView()
                    .controlSize(.small)
            } else {
                url.fastDefaultImage
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.secondary)
                    .padding(4)
            }
        }
        .frame(width: size.width, height: size.height)
        .background(backgroundColor)
        .clipShape(shape)
        .overlay {
            if state.error != nil {
                shape.strokeBorder(color: Color.red.opacity(0.5))
            }
        }
        .contextMenu {
            if showContextMenu && url.isFileURL {
                Button("设置封面") {
                    isImagePickerPresented = true
                }

                Divider()
            }
        }
        .fileImporter(
            isPresented: $isImagePickerPresented,
            allowedContentTypes: [.image],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case let .success(files):
                if let selectedURL = files.first {
                    Task {
                        do {
                            if self.verbose { os_log("\(self.t)🎨 开始设置封面：\(selectedURL.lastPathComponent)") }

                            // 获取文件的安全访问权限
                            guard selectedURL.startAccessingSecurityScopedResource() else {
                                let accessError = NSError(domain: "AvatarView", code: -1, userInfo: [NSLocalizedDescriptionKey: "无法获取文件访问权限"])
                                if self.verbose { os_log(.error, "\(self.t)🎨 无法获取文件访问权限") }
                                state.setError(ViewError.thumbnailGenerationFailed(accessError))
                                return
                            }

                            defer {
                                // 完成后释放访问权限
                                selectedURL.stopAccessingSecurityScopedResource()
                            }

                            let imageData = try Data(contentsOf: selectedURL)
                            try await url.writeCoverToMediaFile(
                                imageData: imageData,
                                imageType: "image/jpeg",
                                verbose: verbose
                            )
                            // 重新加载缩略图
                            state.reset()
                            await loadThumbnail()
                            if self.verbose { os_log("\(self.t)🎨 封面设置成功") }
                        } catch {
                            let errorMessage = "设置封面失败: \(error.localizedDescription)"
                            if self.verbose { os_log(.error, "\(self.t)🎨 设置封面失败: \(error.localizedDescription)") }
                            state.setError(ViewError.thumbnailGenerationFailed(error))
                        }
                    }
                }
            case let .failure(error):
                let errorMessage = "选择图片失败: \(error.localizedDescription)"
                if self.verbose { os_log(.error, "\(self.t)🎨 选择图片失败: \(error.localizedDescription)") }
                state.setError(ViewError.thumbnailGenerationFailed(error))
            }
        }
        .onChange(of: progressBinding?.wrappedValue) {
            if self.verbose { os_log("\(self.t)🔄 外部将下载进度设置为: \(String(describing: progressBinding?.wrappedValue))") }

            if let progress = progressBinding?.wrappedValue, progress >= 1.0 {
                Task {
                    state.reset()
                    await loadThumbnail()
                }
            }
        }
        .task(id: url) { await onTaskWithDelay() }
        .onChange(of: state.needsReload) {
            // 下载完成后触发重新加载缩略图
            if state.needsReload {
                state.clearNeedsReload()
                Task { await loadThumbnail() }
            }
        }
        .onDisappear(perform: onDisappear)
    }
}

// MARK: - Actions

extension AvatarView {
    /// 异步加载文件的缩略图
    /// 根据文件类型和状态决定是否需要生成或加载缩略图
    @Sendable private func loadThumbnail() async {
        let hasThumbnail = state.thumbnail != nil

        if state.isLoading {
            if self.verbose { os_log("\(self.t)跳过缩略图加载：正在加载中") }
            return
        }

        // 使用后台任务队列
        await Task.detached(priority: .utility) {
            if hasThumbnail && url.checkIsDownloaded() {
                if self.verbose { os_log("\(self.t)跳过缩略图加载：已存在缩略图") }
                return
            }
            
            if url.isDownloading {
                if self.verbose { os_log("\(self.t)跳过缩略图加载：文件正在下载中") }
                return
            }
            
            await state.setLoading(true)

            do {
                // 在后台线程中处理图片生成
                let image = try await url.thumbnail(size: size, verbose: verbose && false, reason: self.className + ".loadThumbnail")

                if let image = image {
                    await state.setThumbnail(image)
                    await state.setError(nil)
                }
            } catch URLError.cancelled {
                if self.verbose { os_log("\(self.t)缩略图加载已取消") }
            } catch {
                let viewError: ViewError
                if let urlError = error as? URLError {
                    switch urlError.code {
                    case .notConnectedToInternet, .networkConnectionLost, .timedOut:
                        viewError = .downloadFailed(urlError)
                    case .fileDoesNotExist:
                        viewError = .fileNotFound
                    default:
                        viewError = .thumbnailGenerationFailed(urlError)
                    }
                } else {
                    viewError = .thumbnailGenerationFailed(error)
                }

                await state.setError(viewError)
                if self.verbose { os_log(.error, "\(self.t)<\(url.title)>加载缩略图失败: \(viewError.localizedDescription)") }
            }

            await state.setLoading(false)
        }.value
    }

    /// 设置下载进度监控器
    /// 仅对iCloud文件且未绑定外部进度时启动监控
    /// 使用全局下载监控器，避免多个视图重复创建监听器
    /// 耗时操作在后台线程执行，仅 UI 更新在主线程
    @Sendable private func setupDownloadMonitor() async {
        // 前置条件检查（progressBinding 是值类型，可以安全检查）
        guard monitorDownload && progressBinding == nil else {
            return
        }
        
        // 在后台线程执行 iCloud 检查和订阅操作
        let cancellable = await Task.detached(priority: .utility) { [url, verbose, state] () -> AnyCancellable? in
            // iCloud 检查涉及文件系统 I/O，放在后台线程
            guard url.checkIsICloud(verbose: false) else {
                return nil
            }
            
            if verbose { os_log("\(AvatarView.t)<\(url.title)>在后台线程创建下载监控订阅") }
            
            // 订阅操作也在后台线程执行（subscribe 是 async 方法）
            return await GlobalDownloadMonitor.shared
                .subscribe(url: url)
                .receive(on: DispatchQueue.main) // 仅 sink 回调在主线程更新 UI
                .sink { progress in
                    // 使用 Task 调用 @MainActor 隔离的方法
                    Task { @MainActor in
                        // 更新进度状态（主线程）
                        state.setProgress(progress)

                        // 如果下载失败（进度为负数），设置相应的错误
                        if progress < 0 {
                            if verbose { os_log(.error, "\(AvatarView.t)<\(url.title)>下载失败") }
                            state.setError(ViewError.downloadFailed(nil))
                        }

                        // 如果下载完成
                        if progress >= 1.0 {
                            if verbose { os_log("\(AvatarView.t)<\(url.title)>下载完成，标记需要重新加载缩略图") }
                            // 标记需要重新加载，视图会通过 onChange 监听此变化并触发加载
                            state.markNeedsReload()
                        }
                    }
                    
                    // 下载完成后在后台线程取消订阅
                    if progress >= 1.0 {
                        Task.detached(priority: .utility) {
                            await GlobalDownloadMonitor.shared.unsubscribe(url: url)
                        }
                    }
                }
        }.value
        
        // 在主线程更新订阅状态
        await MainActor.run {
            // 如果已有订阅，先取消并清理（防止重复订阅导致内存泄漏）
            if progressCancellable != nil {
                if verbose { os_log("\(Self.t)<\(url.title)>检测到重复订阅，先取消旧订阅") }
                progressCancellable?.cancel()
                // 在后台线程执行取消订阅
                Task.detached(priority: .utility) { [url] in
                    await GlobalDownloadMonitor.shared.unsubscribe(url: url)
                }
            }
            
            progressCancellable = cancellable
        }
    }
}

// MARK: - Event Handler

extension AvatarView {
    /// 处理视图出现时的事件（带延迟）
    /// 延迟加载缩略图，防止快速滚动时触发过多任务
    private func onTaskWithDelay() async {
        // 延迟指定时间，如果 cell 仍然可见才加载
        // 这样快速滚动时，已经滚出屏幕的 cell 不会触发加载
        do {
            try await Task.sleep(nanoseconds: loadDelay * 1_000_000)
        } catch {
            // 任务被取消，说明视图已经不可见
            return
        }
        
        // 检查任务是否被取消
        guard !Task.isCancelled else { return }
        
        if state.error == nil {
            await loadThumbnail()
        }
        // 对 iCloud 文件启用下载进度监控（setupDownloadMonitor 内部会检查是否为 iCloud 文件）
        if monitorDownload {
            await setupDownloadMonitor()
        }
    }

    /// 处理视图消失时的事件
    /// 取消订阅全局下载监控
    private func onDisappear() {
        if monitorDownload && url.checkIsICloud(verbose: false) && progressBinding == nil {
            GlobalDownloadMonitor.shared.unsubscribe(url: url)
        }
    }
}

// MARK: - Preview

#if DEBUG
    #Preview("头像视图") {
        AvatarDemoView()
    }
#endif
