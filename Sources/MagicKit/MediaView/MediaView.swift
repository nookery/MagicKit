import SwiftUI
import OSLog

/// 显示媒体文件的视图组件
/// 显示文件信息、头像、操作按钮，并支持悬停交互和日志查看
public struct MediaFileView: View, SuperLog {
    /// 是否启用详细日志输出
    static let verbose = false

    /// 表情符号标识符
    public nonisolated static let emoji = "🖥️"

    /// 是否正在悬停状态
    @State private var isHovering = false

    /// 文件URL
    let url: URL

    /// 是否启用详细日志
    var verbose: Bool

    /// 视图样式
    var style: MediaViewStyle = .none

    /// 日志视图样式
    var logStyle: LogViewStyle = .sheet

    /// 是否显示操作按钮
    var showActions: Bool = true

    /// 头像形状
    var avatarShape: AvatarViewShape = .circle

    /// 头像背景色
    var avatarBackgroundColor: Color = .blue.opacity(0.1)

    /// 头像尺寸
    var avatarSize: CGSize = CGSize(width: 40, height: 40)

    /// 垂直内边距
    var verticalPadding: CGFloat = 12

    /// 水平内边距
    var horizontalPadding: CGFloat = 16

    /// 是否监控下载进度
    var monitorDownload: Bool = true

    /// 文件夹内容是否可见
    var folderContentVisible: Bool = false

    /// 头像进度绑定
    var avatarProgressBinding: Binding<Double>? = nil

    /// 是否显示边框
    var showBorder: Bool = false

    /// 是否显示下载按钮
    var showDownloadButton: Bool = true

    /// 是否显示文件信息
    var showFileInfo: Bool = true

    /// 是否显示文件状态
    var showFileStatus: Bool = true

    /// 是否显示文件大小
    var showFileSize: Bool = true

    /// 是否显示头像
    var showAvatar: Bool = true

    /// 是否显示日志按钮
    var showLogButton: Bool = true

    /// 初始化媒体文件视图
    /// - Parameters:
    ///   - url: 文件URL
    ///   - verbose: 是否启用详细日志
    public init(url: URL, verbose: Bool) {
        self.url = url
        self.verbose = verbose
    }

    public var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .trailing) {
                HStack(alignment: .center, spacing: 12) {
                    if showAvatar {
                        AvatarSection(
                            url: url,
                            verbose: verbose,
                            avatarShape: avatarShape,
                            avatarSize: avatarSize,
                            avatarBackgroundColor: avatarBackgroundColor,
                            monitorDownload: monitorDownload,
                            showBorder: showBorder,
                            isHovering: isHovering
                        )
                    }

                    FileInfoSection(
                        url: url,
                        showFileSize: showFileSize,
                        showFileStatus: showFileStatus,
                        showBorder: showBorder
                    )

                    Spacer()
                }

                if showActions {
                    ActionButtonsSection(
                        url: url,
                        showDownloadButton: showDownloadButton,
                        showLogSheet: .constant(false),
                        horizontalPadding: horizontalPadding,
                        showBorder: showBorder,
                        isHovering: isHovering
                    )
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
        }
        .modifier(FolderContentModifier(url: url, isVisible: folderContentVisible))
        .modifier(MediaViewBackground(style: style))
        .overlay(
            RoundedRectangle(cornerRadius: 0)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [4]))
                .foregroundColor(showBorder ? .red : .clear)
        )
        .conditionalHover(isEnabled: showActions) { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovering = hovering
            }
        }
    }
}


#if DEBUG
#Preview("Media View") {
    MediaViewPreviewContainer()
}
#endif
