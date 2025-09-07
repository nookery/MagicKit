import SwiftUI

/// 单个Toast视图
struct MagicToastView: View {
    let toast: MagicToastModel
    let onDismiss: (UUID) -> Void

    @State private var progress: Double = 1.0
    @State private var isVisible = false
    @State private var dragOffset = CGSize.zero

    var body: some View {
        VStack(spacing: 16) {
            // 图标
            iconView

            // 内容
            VStack(spacing: 4) {
                Text(toast.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)

                if let subtitle = toast.subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .frame(width: 180, height: 180)
        .background(backgroundView)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 4)
        .scaleEffect(isVisible ? 1.0 : 0.8)
        .opacity(isVisible ? 0.95 : 0.0)
        .offset(y: dragOffset.height)
        .gesture(
            toast.tapToDismiss ?
                DragGesture()
                .onChanged { value in
                    dragOffset = value.translation
                }
                .onEnded { value in
                    if abs(value.translation.height) > 50 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            onDismiss(toast.id)
                        }
                    } else {
                        withAnimation(.spring()) {
                            dragOffset = .zero
                        }
                    }
                }
                : nil
        )
        .onTapGesture {
            if toast.tapToDismiss {
                toast.onTap?()
                withAnimation(.easeInOut(duration: 0.3)) {
                    onDismiss(toast.id)
                }
            } else {
                toast.onTap?()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isVisible = true
            }

            // 进度条动画
            if toast.autoDismiss && toast.duration > 0 {
                withAnimation(.linear(duration: toast.duration)) {
                    progress = 0.0
                }
            }
        }
        .overlay(alignment: .topTrailing) {
            // 关闭按钮（仅在不自动消失时显示）
            if !toast.autoDismiss {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        onDismiss(toast.id)
                    }
                }) {
                    Image(systemName: "xmark")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(width: 24, height: 24)
                        .background(Color.secondary.opacity(0.1))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
                .padding(8)
                .contentShape(Rectangle())
            }
        }
        .overlay(alignment: .bottom) {
            // 进度条
            if toast.showProgress && toast.autoDismiss && toast.duration > 0 {
                GeometryReader { geometry in
                    Rectangle()
                        .fill(toast.type.color)
                        .frame(width: geometry.size.width * progress, height: 2)
                        .animation(.linear(duration: toast.duration), value: progress)
                }
                .frame(height: 2)
            }
        }
    }

    @ViewBuilder
    private var iconView: some View {
        Group {
            if case .loading = toast.type {
                // 加载动画
                Image(systemName: toast.type.systemImage)
                    .foregroundColor(toast.type.color)
                    .rotationEffect(.degrees(isVisible ? 360 : 0))
                    .animation(.linear(duration: 1.0).repeatForever(autoreverses: false), value: isVisible)
            } else {
                // 静态图标
                Image(systemName: toast.type.systemImage)
                    .foregroundColor(toast.type.color)
            }
        }
        .font(.system(size: 64))
        .frame(width: 72, height: 72)
    }

    @ViewBuilder
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.regularMaterial)
    }
}

#if DEBUG
    #Preview {
        MagicToastExampleView()
            .withMagicToast()
            .frame(width: 400, height: 600)
    }
#endif
