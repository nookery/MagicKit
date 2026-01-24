import SwiftUI

struct AvatarSection: View {
    let url: URL
    let verbose: Bool
    let avatarShape: AvatarViewShape
    let avatarSize: CGSize
    let avatarBackgroundColor: Color
    let monitorDownload: Bool
    let showBorder: Bool
    let isHovering: Bool

    var body: some View {
        url.makeAvatarView(verbose: verbose)
            .magicSize(avatarSize)
            .magicAvatarShape(avatarShape)
            .magicBackground(avatarBackgroundColor)
            .magicDownloadMonitor(monitorDownload)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [4]))
                    .foregroundColor(showBorder ? .blue : .clear)
            )
    }
}

#if DEBUG
    #Preview {
        AvatarSection(
            url: URL(string: "https://example.com")!,
            verbose: true,
            avatarShape: .circle,
            avatarSize: CGSize(width: 40, height: 40),
            avatarBackgroundColor: .blue.opacity(0.1),
            monitorDownload: true,
            showBorder: true,
            isHovering: false
        )
    }
#endif
