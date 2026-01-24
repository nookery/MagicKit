import SwiftUI

extension AvatarView {
    /// 缩略图显示视图组件
    struct ThumbnailView: View {
        let image: Image
        let shape: AvatarViewShape
        let size: CGSize
        let backgroundColor: Color

        var padding: CGFloat {
            // 如果是圆形
            if case .circle = shape {
                return self.size.width * 0.2
            }

            return self.size.width * 0.1
        }

        init(image: Image, shape: AvatarViewShape = .circle, size: CGSize, backgroundColor: Color = .blue.opacity(0.1)) {
            self.image = image
            self.shape = shape
            self.size = size
            self.backgroundColor = backgroundColor
        }

        var body: some View {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .padding(padding)
                .frame(width: size.width, height: size.height)
                .background(backgroundColor)
                .clipShape(shape)
        }
    }
}

// MARK: - Preview

#if DEBUG
    #Preview("基础样式") {
        AvatarDemoView()
            .frame(width: 500, height: 600)
    }

    #Preview {
        AvatarView.ThumbnailView(
            image: .code,
            shape: .circle,
            size: CGSize(width: 300, height: 300),
            backgroundColor: .red.opacity(0.1)
        )
        .magicCentered()
        .frame(width: 500, height: 600)
    }
#endif
