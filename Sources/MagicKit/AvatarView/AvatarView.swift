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
/// ```
public struct AvatarView: View, SuperLog {
    // MARK: - Properties

    /// 表情符号标识符
    public static let emoji = "🚉"

    /// 视图状态管理器，管理缩略图、加载状态和错误状态
    @StateObject var state = ViewState()

    /// 全局下载进度订阅
    @State private var progressCancellable: AnyCancellable? = nil

    /// 文件的URL
    let url: URL

    /// 是否启用详细日志输出
    let verbose: Bool

    /// 视图的形状样式
    var shape: AvatarViewShape = .circle

    /// 是否监控下载进度（仅对iCloud文件有效）
    var monitorDownload: Bool = true

    /// 视图尺寸
    var size: CGSize = CGSize(width: 40, height: 40)

    /// 视图背景色
    var backgroundColor: Color = .blue.opacity(0.1)

    // MARK: - Computed Properties

    /// 当前的下载进度
    private var downloadProgress: Double {
        state.autoDownloadProgress
    }

    /// 是否正在下载
    private var isDownloading: Bool {
        downloadProgress > 0 && downloadProgress <= 1
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
                DownloadingView(progress: downloadProgress)
                    .frame(width: size.width, height: size.height)
                    .background(backgroundColor)
            } else if let thumbnail = state.thumbnail {
                ThumbnailView(
                    image: thumbnail,
                    shape: shape,
                    size: size,
                    backgroundColor: backgroundColor
                )
            } else if let error = state.error {
                ErrorView(
                    error: error,
                    shape: shape,
                    size: size,
                    backgroundColor: backgroundColor
                )
            } else if state.isLoading {
                ProgressView()
                    .controlSize(.small)
                    .frame(width: size.width, height: size.height)
                    .background(backgroundColor)
            } else {
                url.fastDefaultImage
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.secondary)
                    .padding(4)
                    .frame(width: size.width, height: size.height)
                    .background(backgroundColor)
            }
        }
        .task(id: url) { await onTask() }
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
    /// 检查是否可以跳过延迟（缓存可用时不需要延迟）
    /// - Returns: 如果可以跳过延迟返回 true
    private func canSkipDelay() async -> Bool {
        // 在后台线程检查文件状态
        return await Task.detached(priority: .utility) { [url] in
            url.isDownloaded || url.isNotiCloud
        }.value
    }

    /// 异步加载文件的缩略图
    /// 根据文件类型和状态决定是否需要生成或加载缩略图
    private func loadThumbnail() async {
        let hasThumbnail = state.thumbnail != nil

        if state.isLoading {
            return
        }

        // 显式捕获所有需要的值，避免捕获 self
        let capturedUrl = url
        let capturedSize = size
        let capturedState = state

        // 使用后台任务队列
        await Task.detached(priority: .utility) { [hasThumbnail] in
            if hasThumbnail && capturedUrl.checkIsDownloaded() {
                return
            }

            if capturedUrl.checkIsDownloading(verbose: false) {
                return
            }

            await capturedState.setLoading(true)

            do {
                let image = try await capturedUrl.thumbnail(
                    size: capturedSize,
                    verbose: false,
                    reason: self.className + ".loadThumbnail"
                )

                if let image = image {
                    await capturedState.setThumbnail(image)
                    await capturedState.setError(nil)
                }
            } catch URLError.cancelled {
                // 任务被取消，忽略
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

                await capturedState.setError(viewError)
            }

            await capturedState.setLoading(false)
        }.value
    }

    /// 设置下载进度监控器
    /// 仅对iCloud文件启动监控
    private func setupDownloadMonitor() async {
        guard monitorDownload else {
            return
        }

        // 显式捕获需要的值
        let capturedUrl = url
        let capturedState = state

        // 在后台线程检查是否为 iCloud 文件
        let isICloud = await Task.detached(priority: .utility) {
            capturedUrl.checkIsICloud(verbose: false)
        }.value

        guard isICloud else {
            return
        }

        // ⚠️ 重要：先取消旧订阅，再创建新订阅，避免引用计数混乱
        if let oldCancellable = progressCancellable {
            oldCancellable.cancel()
            progressCancellable = nil
            await AvatarDownloadMonitor.shared.unsubscribe(url: capturedUrl)
        }

        // 创建新订阅
        let cancellable = await AvatarDownloadMonitor.shared
            .subscribe(url: capturedUrl)
            .receive(on: DispatchQueue.main)
            .sink { [capturedState, capturedUrl] progress in
                // 更新进度状态
                capturedState.setProgress(progress)

                // 如果下载失败
                if progress < 0 {
                    capturedState.setError(ViewError.downloadFailed(nil))
                }

                // 如果下载完成
                if progress >= 1.0 {
                    capturedState.markNeedsReload()
                    // 取消订阅
                    Task {
                        await AvatarDownloadMonitor.shared.unsubscribe(url: capturedUrl)
                    }
                }
            }

        progressCancellable = cancellable
    }
}

// MARK: - Event Handler

extension AvatarView {
    /// 处理视图出现时的事件
    /// 优化策略：对于已下载/本地文件跳过延迟直接加载（因为会从缓存读取）
    private func onTask() async {
        // 如果已有缩略图，无需加载
        if state.thumbnail != nil {
            // 仍然需要设置下载监控
            if monitorDownload {
                await setupDownloadMonitor()
            }
            return
        }

        // 检查是否可以跳过延迟（已下载或本地文件可以从缓存快速加载）
        let skipDelay = await canSkipDelay()

        if !skipDelay {
            // 需要延迟加载（未下载的 iCloud 文件等）
            do {
                try await Task.sleep(nanoseconds: loadDelay * 1000000)
            } catch {
                // 任务被取消
                return
            }

            guard !Task.isCancelled else { return }
        }

        // 加载缩略图
        if state.error == nil {
            await loadThumbnail()
        }

        // 对 iCloud 文件启用下载进度监控
        if monitorDownload {
            await setupDownloadMonitor()
        }
    }

    /// 处理视图消失时的事件
    /// 取消所有订阅，释放资源
    private func onDisappear() {
        // 先清空本地引用，防止重复取消
        let oldCancellable = progressCancellable
        progressCancellable = nil

        // 取消 Combine 订阅
        oldCancellable?.cancel()

        // 取消全局下载监控订阅（使用 Task 而非 detached，确保在主线程执行）
        let capturedUrl = url
        Task { @MainActor in
            await AvatarDownloadMonitor.shared.unsubscribe(url: capturedUrl)
        }
    }
}

// MARK: - Preview

#if DEBUG
    #Preview("基础样式") {
        AvatarBasicPreview()
            .frame(width: 500, height: 600)
    }
#endif
