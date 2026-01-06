import SwiftUI

/// 差异视图中的行号区域视图
struct DiffLineNumberView: View {
    let line: DiffLine
    let displayMode: MagicDiffViewMode
    let font: Font

    var body: some View {
        HStack(spacing: 0) {
            switch displayMode {
            case .diff:
                lineNumberText(line.oldLineNumber, color: .secondary.opacity(0.8))
                separatorLine()
                lineNumberText(line.newLineNumber, color: .secondary.opacity(0.8))
            case .original:
                lineNumberText(line.oldLineNumber, color: .secondary.opacity(0.8))
            case .modified:
                lineNumberText(line.newLineNumber, color: .secondary.opacity(0.8))
            }
        }
        .padding(.horizontal, 0)
        .background(gutterBackgroundColor)
        .frame(maxHeight: .infinity)
        // 在行号区域右侧添加垂直分割线，分隔行号和代码内容区域
        .overlay(
            separatorLine(),
            alignment: .trailing  // 对齐到行号区域右侧
        )
    }

    /// 创建统一的垂直分割线
    private func separatorLine() -> some View {
        Rectangle()
            .frame(width: 1)
            .foregroundColor(Color.secondary.opacity(0.15))
    }

    /// 生成行号文本视图
    private func lineNumberText(_ number: Int?, color: Color) -> some View {
        Text(number.map(String.init) ?? "")
            .font(font)
            .foregroundColor(color)
            .frame(width: 36, alignment: .trailing)
            .padding(.horizontal, 4)
    }

    /// 行号区域背景颜色
    private var gutterBackgroundColor: Color {
        switch line.type {
        case .added:
            return Color.green.opacity(0.15)
        case .removed:
            return Color.red.opacity(0.15)
        case .unchanged:
            return Color.clear
        case .modified:
            return Color.orange.opacity(0.15)
        }
    }
}
