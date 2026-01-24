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

    /// 设置是否监控下载进度
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
    
    /// 设置缩略图加载延迟时间
    ///
    /// 用于优化列表滚动性能。设置延迟后，只有在视图可见超过指定时间后才会开始加载缩略图。
    /// 这样在快速滚动时，已经滚出屏幕的视图不会触发不必要的加载操作。
    ///
    /// ## 使用示例：
    /// ```swift
    /// // 设置 200ms 延迟，适合快速滚动场景
    /// url.makeAvatarView()
    ///     .magicLoadDelay(200)
    ///
    /// // 设置 0ms 延迟，立即加载（默认行为）
    /// url.makeAvatarView()
    ///     .magicLoadDelay(0)
    /// ```
    ///
    /// - Parameter milliseconds: 延迟时间（毫秒），默认 150ms
    /// - Returns: 修改后的视图
    func magicLoadDelay(_ milliseconds: UInt64) -> AvatarView {
        var view = self
        view.loadDelay = milliseconds
        return view
    }
}

// MARK: - Preview

#if DEBUG
    #Preview("基础样式") {
        AvatarDemoView()
            .frame(width: 500, height: 600)
    }
#endif
