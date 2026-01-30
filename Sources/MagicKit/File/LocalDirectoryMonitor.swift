import Combine
import Darwin
import Foundation
import OSLog

/// 监听本地文件夹内容变化的专用类
/// - Note: 使用 FSEvents 和 DispatchSource 进行文件系统事件监听
public final class LocalDirectoryMonitor: SuperLog {
    public static let emoji = "💼"
    
    // MARK: - Types

    public typealias onChangeCallback = @Sendable (_ files: [URL], _ isInitialFetch: Bool, _ error: Error?) async -> Void

    /// 监听器状态管理（使用 Actor 确保线程安全）
    private actor MonitorState {
        private var isFirstFetch = true

        func getAndUpdateFirstFetch() -> Bool {
            let current = isFirstFetch
            isFirstFetch = false
            return current
        }
    }

    // MARK: - Properties

    private let directoryURL: URL
    private let verbose: Bool
    private let caller: String
    private let onChange: onChangeCallback

    private var fileDescriptor: Int32 = -1
    private var monitor: DispatchSourceFileSystemObject?
    private var scanTask: Task<Void, Never>?
    private let state = MonitorState()

    // MARK: - Initialization

    /// 初始化本地目录监听器
    /// - Parameters:
    ///   - directoryURL: 要监听的目录 URL
    ///   - verbose: 是否打印详细日志
    ///   - caller: 调用者名称
    ///   - onChange: 变化回调
    public init(
        directoryURL: URL,
        verbose: Bool,
        caller: String,
        onChange: @escaping onChangeCallback
    ) {
        self.directoryURL = directoryURL
        self.verbose = verbose
        self.caller = caller
        self.onChange = onChange
    }

    // MARK: - Public Methods

    /// 启动监听
    /// - Returns: 取消令牌
    @discardableResult
    public func start() -> AnyCancellable {
        guard setupFileDescriptor() else {
            return AnyCancellable {}
        }

        setupMonitor()
        performInitialScan()

        return AnyCancellable { [weak self] in
            self?.cancel()
        }
    }

    // MARK: - Private Methods

    private func setupFileDescriptor() -> Bool {
        fileDescriptor = Darwin.open(self.directoryURL.path, O_EVTONLY)
        guard fileDescriptor >= 0 else {
            os_log(.error, "\(self.t)❌ (\(self.caller)) 打开文件描述符失败")
            return false
        }

        if verbose {
            os_log("\(self.t)🎯 (\(self.caller)) 已打开文件描述符")
            os_log("\(self.t)  • 目录：\(self.directoryURL.lastPathComponent)")
        }

        return true
    }

    private func setupMonitor() {
        monitor = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fileDescriptor,
            eventMask: [.write, .delete, .rename],
            queue: .global(qos: .background)
        )

        monitor?.setEventHandler { [weak self] in
            Task { [weak self] in
                await self?.handleFileSystemEvent()
            }
        }

        monitor?.resume()

        if verbose {
            os_log("\(self.t)👀 (\(self.caller)) 正在监控目录")
            os_log("\(self.t)  • 目录：\(self.directoryURL.lastPathComponent)")
        }
    }

    private func performInitialScan() {
        scanTask = Task {
            do {
                try await scanDirectory()
            } catch {
                await onChange([], false, error)
            }
        }
    }

    private func handleFileSystemEvent() async {
        do {
            try await scanDirectory()
        } catch {
            await onChange([], false, error)
        }
    }

    private func scanDirectory() async throws {
        if verbose {
            os_log("\(self.t)🔍 (\(self.caller)) 扫描目录")
        }

        let fileManager = FileManager.default

        guard fileManager.fileExists(atPath: self.directoryURL.path) else {
            os_log(.error, "\(self.t)❌ (\(self.caller)) 目录不存在")
            throw URLError(.fileDoesNotExist)
        }

        let urls = try fileManager.contentsOfDirectory(
            at: self.directoryURL,
            includingPropertiesForKeys: [.contentModificationDateKey],
            options: [.skipsHiddenFiles]
        )

        if verbose {
            os_log("\(self.t)📝 (\(self.caller)) 扫描完成")
            os_log("\(self.t)  • 文件数量：\(urls.count)")

            // 打印文件列表
            for i in 0..<min(urls.count, 10) {
                os_log("\(self.t)  • [\(i)] \(urls[i].lastPathComponent)")
            }

            if urls.count > 10 {
                os_log("\(self.t)  • ... 还有 \(urls.count - 10) 个文件")
            }
        }

        let isFirstFetch = await state.getAndUpdateFirstFetch()
        await onChange(urls, isFirstFetch, nil)
    }

    private func cancel() {
        if verbose {
            os_log("\(self.t)⏹️ (\(self.caller)) 停止本地监控器")
        }

        scanTask?.cancel()
        monitor?.cancel()
        if fileDescriptor >= 0 {
            Darwin.close(fileDescriptor)
        }
    }
}
