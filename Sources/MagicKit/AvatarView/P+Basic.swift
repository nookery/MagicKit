#if DEBUG
    import SwiftUI

    /// 头像视图基础样式预览
    public struct AvatarBasicPreview: View {
        public init() {}

        public var body: some View {
            VStack(spacing: 32) {
                // 默认样式
                AvatarPreviewHelpers.demoSection("默认样式") {
                    HStack(spacing: 20) {
                        URL.sample_web_jpg_earth.makeAvatarView()

                        URL.sample_web_mp3_kennedy.makeAvatarView()

                        URL.sample_web_mp4_bunny.makeAvatarView()
                    }
                }

                // 自定义背景色
                AvatarPreviewHelpers.demoSection("自定义背景色") {
                    HStack(spacing: 20) {
                        URL.sample_web_jpg_earth.makeAvatarView()
                            .magicBackground(.red.opacity(0.1))

                        URL.sample_web_jpg_earth.makeAvatarView()
                            .magicBackground(.green.opacity(0.1))
                            .magicAvatarShape(.hexagon)

                        URL.sample_web_jpg_earth.makeAvatarView()
                            .magicBackground(.purple.opacity(0.1))
                    }
                }

                // 不同尺寸
                AvatarPreviewHelpers.demoSection("不同尺寸") {
                    HStack(spacing: 20) {
                        URL.sample_web_jpg_earth.makeAvatarView()
                            .magicSize(32)

                        URL.sample_web_jpg_earth.makeAvatarView()
                            .magicSize(48)

                        URL.sample_web_jpg_earth.makeAvatarView()
                            .magicSize(64)
                    }
                }

                // 不同形状
                AvatarPreviewHelpers.demoSection("不同形状") {
                    HStack(spacing: 20) {
                        URL.sample_web_jpg_earth.makeAvatarView()
                            .magicAvatarShape(.circle)

                        URL.sample_web_jpg_earth.makeAvatarView()
                            .magicAvatarShape(.roundedRectangle(cornerRadius: 8))

                        URL.sample_web_jpg_earth.makeAvatarView()
                            .magicAvatarShape(.rectangle)
                    }
                }
            }
            .padding()
            .infinite()
        }
    }

    // MARK: - Preview

    #Preview("基础样式") {
        AvatarBasicPreview()
            .frame(width: 500, height: 600)
    }
#endif
