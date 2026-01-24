import SwiftUI

extension AvatarView {
    /// 缩略图显示视图组件
    struct ThumbnailView: View {
        let image: Image

        var body: some View {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
}

#if DEBUG
    #Preview {
        AvatarView.ThumbnailView(image: .videoDocument)
            .frame(width: 300, height: 300)
            .magicCentered()
    }
#endif
