import SwiftUI
import OSLog

/// 差异视图的主要内容组件
struct DiffContentView: View {
    public nonisolated static let emoji = "📋"
    
    let diffItems: [DiffItem]
    let showLineNumbers: Bool
    let font: Font
    let selectedLanguage: CodeLanguage
    let displayMode: MagicDiffViewMode
    let verbose: Bool
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(Array(diffItems.enumerated()), id: \.offset) { index, item in
                    switch item {
                    case let .line(line):
                        diffLineItem(line)
                    case let .collapsibleBlock(block):
                        diffBlockItem(block)
                    }
                }
            }
        }
    }
    
    /// 创建差异视图中的单行项目视图
    ///
    /// 根据给定的差异行数据和配置，生成包含行号、内容和可选分割线的视图组件
    ///
    /// - Parameters:
    ///   - line: 差异行数据，包含内容、类型、行号等信息
    ///   - showSeparatorLine: 是否在行底部显示分割线，默认为 false
    /// - Returns: 配置完成的单行差异视图
    @ViewBuilder
    private func diffLineItem(_ line: DiffLine, showSeparatorLine: Bool = false) -> some View {
        let lineView = DiffLineView(
            line: line,
            showLineNumbers: showLineNumbers,
            font: font,
            codeLanguage: selectedLanguage,
            displayMode: displayMode,
            verbose: verbose
        )

        // 根据配置决定是否添加分割线
        if showSeparatorLine {
            lineView
                // 添加行与行之间的分割线
                .overlay(
                    Rectangle()
                        .frame(height: 0.5)  // 分割线高度为 0.5 点
                        .foregroundColor(Color.secondary.opacity(0.1)),  // 使用半透明的次要颜色
                    alignment: .bottom  // 对齐到行底部
                )
        } else {
            lineView
        }
    }
    
    /// 差异视图中的折叠块项目
    private func diffBlockItem(_ block: CollapsibleBlock) -> some View {
        CollapsibleBlockView(
            block: block,
            showLineNumbers: showLineNumbers,
            font: font,
            displayMode: displayMode
        )
    }
    
    init(
        diffItems: [DiffItem],
        showLineNumbers: Bool,
        font: Font = .system(.body, design: .monospaced),
        selectedLanguage: CodeLanguage,
        displayMode: MagicDiffViewMode = .diff,
        verbose: Bool = false
    ) {
        self.diffItems = diffItems
        self.showLineNumbers = showLineNumbers
        self.font = font
        self.selectedLanguage = selectedLanguage
        self.displayMode = displayMode
        self.verbose = verbose
    }
}

// MARK: - Preview

#Preview("MagicDiffPreviewView") {
    MagicDiffPreviewView()
}
