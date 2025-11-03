import MagicCore
import SwiftUI
import MagicUI

/// 上一曲按钮视图
/// 
/// 这是一个自观察的按钮视图，会自动监听 MagicPlayMan 的播放列表状态变化。
/// 根据当前播放位置和播放列表状态智能管理按钮的可用性。
/// 
/// ## 特性
/// - 自动响应播放列表状态变化
/// - 智能禁用状态管理（无媒体、播放列表禁用、首曲等）
/// - 支持自定义按钮尺寸
/// - 使用 MagicButton 的次要样式
/// 
/// ## 使用示例
/// ```swift
/// PreviousButtonView(man: playMan, size: .large)
/// ```
/// 
/// - Parameters:
///   - man: MagicPlayMan 实例，用于监听播放列表状态和触发上一曲操作
///   - size: 按钮尺寸，默认为 .regular
struct PreviousButtonView: View {
    @ObservedObject var man: MagicPlayMan
    let size: MagicButton.Size

    /// 计算按钮的禁用原因
    /// 
    /// 根据当前状态返回相应的禁用提示信息：
    /// - 无媒体加载时：显示 "No media loaded"
    /// - 播放列表禁用且无导航订阅者时：显示相应提示
    /// - 播放列表首曲时：显示 "This is the first track"
    var disabledReason: String? {
        if !man.hasAsset {
            return "No media loaded"
        } else if !man.isPlaylistEnabled && !man.events.hasNavigationSubscribers {
            return "Playlist is disabled and no handler for previous track"
        } else if man.isPlaylistEnabled && man.currentIndex <= 0 {
            return "This is the first track"
        }
        return nil
    }

    var body: some View {
        MagicButton.simple(
            icon: .iconBackwardEndFill,
            style: .secondary,
            size: size,
            shape: .circle,
            disabledReason: disabledReason,
            action: man.previous
        )
    }
}

// MARK: - Preview

#Preview("MagicPlayMan") {
    MagicPlayMan
        .PreviewView()
        
}


