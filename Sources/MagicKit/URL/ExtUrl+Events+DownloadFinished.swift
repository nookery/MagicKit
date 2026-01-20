import Foundation
import Combine
import SwiftUI
import OSLog

public extension URL {    
    /// 监听文件下载完成事件
    /// - Parameters:
    ///   - verbose: 是否打印详细日志
    ///   - caller: 调用者名称
    ///   - onFinished: 下载完成回调
    /// - Returns: 可用于取消监听的 AnyCancellable
    func onDownloadFinished(
        verbose: Bool,
        caller: String,
        _ onFinished: @escaping () -> Void
    ) -> AnyCancellable {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .background
        
        let query = NSMetadataQuery()
        query.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
        query.predicate = NSPredicate(format: "%K == %@", NSMetadataItemURLKey, self as NSURL)
        query.operationQueue = queue
        
        if verbose {
            os_log("\(self.t)👂 [\(caller)] 开始监听下载完成 -> \(self.title)")
        }
        
        // 保存 observer token 以便后续移除，避免内存泄漏
        var observer: NSObjectProtocol?
        
        let task = Task {
            let stream = AsyncStream<Notification> { continuation in
                // 设置取消时的清理操作，确保移除 NotificationCenter 观察者
                continuation.onTermination = { _ in
                    if let obs = observer {
                        NotificationCenter.default.removeObserver(obs)
                        observer = nil
                    }
                }
                
                observer = NotificationCenter.default.addObserver(
                    forName: .NSMetadataQueryDidUpdate,
                    object: query,
                    queue: queue
                ) { notification in
                    continuation.yield(notification)
                }
            }
            
            for await _ in stream {
                if let item = query.results.first as? NSMetadataItem, item.isDownloaded {
                    if verbose {
                        os_log("\(self.t)[\(caller)] 下载完成 -> \(self.title)")
                    }
                    await MainActor.run {
                        onFinished()
                    }
                    query.stop()
                    break
                }
            }
        }
        
        query.start()
        
        return AnyCancellable {
            if verbose {
                os_log("\(self.t)🔚🔚🔚 [\(caller)] 停止监听下载完成 -> \(self.title)")
            }
            task.cancel()
            query.stop()
            // 确保移除观察者，防止内存泄漏
            if let obs = observer {
                NotificationCenter.default.removeObserver(obs)
                observer = nil
            }
        }
    }
} 
