import SwiftUI

// MARK: - View Modifiers
public extension AvatarView {
    /// 设置视图的形状
    /// - Parameter shape: 要应用的形状
    /// - Returns: 修改后的视图
    func magicAvatarShape(_ shape: AvatarViewShape) -> AvatarView {
        var view = self
        view.shape = shape
        return view
    }

    /// 设置下载进度绑定
    /// - Parameter progress: 进度绑定
    /// - Returns: 修改后的视图
    func magicDownloadProgress(_ progress: Binding<Double>) -> AvatarView {
        var view = self
        view.progressBinding = progress
        return view
    }

    /// 设置是否监控下载进度
    ///
    /// **✅ 内部使用全局监控器，现在可以安全地在任何场景下启用！**
    ///
    /// MagicKit 会自动管理下载进度监听器的生命周期：
    /// - 每个 URL 只创建一个监听器
    /// - 多个视图自动共享同一个进度源
    /// - 引用计数归零时自动清理
    ///
    /// ## 使用示例：
    /// ```swift
    /// // ✅ 列表中直接使用
    /// url.makeAvatarView()
    ///     .magicDownloadMonitor(true)
    ///
    /// // ✅ 播放器中使用
    /// currentTrackURL.makeAvatarView()
    ///     .magicDownloadMonitor(true)
    /// ```
    ///
    /// - Parameter monitor: 是否监控下载进度
    /// - Returns: 修改后的视图
    func magicDownloadMonitor(_ monitor: Bool) -> AvatarView {
        var view = self
        view.monitorDownload = monitor
        return view
    }

    /// 设置视图尺寸
    /// - Parameter size: 目标尺寸
    /// - Returns: 修改后的视图
    func magicSize(_ size: CGSize) -> AvatarView {
        var view = self
        view.size = size
        return view
    }
    
    /// 应用形状到视图
    /// - Parameter shape: 要应用的形状
    /// - Returns: 修改后的视图
    func magicApplyShape(_ shape: AvatarViewShape) -> AvatarView {
        var view = self
        view.shape = shape
        return view
    }

    /// 使用自定义宽高设置视图大小
    /// - Parameters:
    ///   - width: 宽度
    ///   - height: 高度
    /// - Returns: 修改后的视图
    func magicSize(width: CGFloat, height: CGFloat) -> AvatarView {
        magicSize(.rectangle(width: width, height: height))
    }

    /// 使用预设尺寸设置视图大小
    /// - Parameter preset: 预设尺寸
    /// - Returns: 修改后的视图
    func magicSize(_ preset: AvatarSize) -> AvatarView {
        var view = self
        view.size = preset.size
        return view
    }
    
    /// 使用正方形边长设置视图大小
    /// - Parameter dimension: 正方形边长
    /// - Returns: 修改后的视图
    func magicSize(_ dimension: CGFloat) -> AvatarView {
        magicSize(.custom(dimension))
    }
    
    /// 设置视图背景色
    /// - Parameter color: 要应用的背景色
    /// - Returns: 修改后的视图
    func magicBackground(_ color: Color) -> AvatarView {
        var view = self
        view.backgroundColor = color
        return view
    }

    /// 设置日志回调
    /// - Parameter callback: 日志回调闭包，接收日志消息和日志级别
    /// - Returns: 修改后的视图
    func onLog(_ callback: @escaping (String, MagicLogEntry.Level) -> Void) -> AvatarView {
        var view = self
        view.onLog = callback
        return view
    }
    
    /// 设置是否显示右键菜单
    /// - Parameter enabled: 是否启用右键菜单
    /// - Returns: 修改后的视图
    func magicContextMenu(_ enabled: Bool) -> AvatarView {
        var view = self
        view.showContextMenu = enabled
        return view
    }
}

// MARK: - Preview
#if DEBUG
#Preview("头像视图") {
    AvatarDemoView()
}
#endif
