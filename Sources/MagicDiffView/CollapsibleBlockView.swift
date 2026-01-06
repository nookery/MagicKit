import SwiftUI

/// 折叠块视图
/// 用于显示可折叠的连续未变动行
struct CollapsibleBlockView: View {
    @State private var block: CollapsibleBlock
    let showLineNumbers: Bool
    let font: Font
    let displayMode: MagicDiffViewMode
    let codeLanguage: CodeLanguage
    let verbose: Bool
    
    /// 创建折叠块视图
    /// - Parameters:
    ///   - block: 折叠块数据
    ///   - showLineNumbers: 是否显示行号
    ///   - font: 字体
    ///   - displayMode: 显示模式
    ///   - codeLanguage: 代码语言，用于语法高亮
    ///   - verbose: 是否启用详细日志
    init(
        block: CollapsibleBlock,
        showLineNumbers: Bool,
        font: Font,
        displayMode: MagicDiffViewMode = .diff,
        codeLanguage: CodeLanguage,
        verbose: Bool
    ) {
        self._block = State(initialValue: block)
        self.showLineNumbers = showLineNumbers
        self.font = font
        self.displayMode = displayMode
        self.codeLanguage = codeLanguage
        self.verbose = verbose
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if block.isCollapsed {
                collapsedView
            } else {
                expandedView
            }
        }
    }
    
    /// 折叠状态的视图
    private var collapsedView: some View {
        Button(action: toggleCollapse) {
            HStack(alignment: .center, spacing: 0) {
                if showLineNumbers {
                    collapsedLineNumberView
                }
                
                collapsedContentView
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color.secondary.opacity(0.05))
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color.secondary.opacity(0.2)),
            alignment: .bottom
        )
    }
    
    /// 展开状态的视图
    private var expandedView: some View {
        VStack(spacing: 0) {
            // 折叠按钮
            Button(action: toggleCollapse) {
                HStack(alignment: .center, spacing: 0) {
                    if showLineNumbers {
                        expandButtonLineNumberView
                    }
                    
                    expandButtonContentView
                }
            }
            .buttonStyle(PlainButtonStyle())
            .background(Color.secondary.opacity(0.05))
            
            // 展开的行
            ForEach(Array(block.lines.enumerated()), id: \.offset) { index, line in
                DiffLineView(
                    line: line,
                    showLineNumbers: showLineNumbers,
                    font: font,
                    codeLanguage: codeLanguage,
                    displayMode: displayMode,
                    verbose: verbose
                )
            }
        }
    }
    
    /// 折叠状态的行号视图
    @ViewBuilder
    private var collapsedLineNumberView: some View {
        HStack(alignment: .center, spacing: 0) {
            Image(systemName: "arrow.up.and.down")
                .font(.system(size: 10))
                .foregroundColor(.blue)
        }
        // Width calculation:
        // Diff Mode: 44 (col 1) + 1 (separator) + 44 (col 2) = 89
        // Original/Modified Mode: 44
        .frame(minWidth: displayMode == .diff ? 89 : 44)
        .frame(maxHeight: .infinity)
        .padding(.vertical, 1)
        .background(Color.blue.opacity(0.1))
        .overlay(
            Rectangle()
                .frame(width: 1)
                .foregroundColor(Color.secondary.opacity(0.1)),
            alignment: .trailing
        )
    }
    
    /// 展开按钮的行号视图
    @ViewBuilder
    private var expandButtonLineNumberView: some View {
        HStack(alignment: .center, spacing: 0) {
            Image(systemName: "arrow.up.and.down")
                .font(.system(size: 10))
                .foregroundColor(.blue)
        }
        .frame(minWidth: displayMode == .diff ? 89 : 44)
        .frame(maxHeight: .infinity)
        .padding(.vertical, 1)
        .background(Color.blue.opacity(0.1))
        .overlay(
            Rectangle()
                .frame(width: 1)
                .foregroundColor(Color.secondary.opacity(0.1)),
            alignment: .trailing
        )
    }
    
    /// 折叠状态的内容视图
    private var collapsedContentView: some View {
        HStack(spacing: 0) {
            // 上下文信息
            if let contextInfo = block.contextInfo {
                Text(contextInfo)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.secondary)
                    .padding(.leading, 8)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    /// 展开按钮的内容视图
    private var expandButtonContentView: some View {
        HStack(spacing: 0) {
            // 上下文信息
            if let contextInfo = block.contextInfo {
                Text(contextInfo)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.secondary)
                    .padding(.leading, 8)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
        .background(Color(red: 0.96, green: 0.97, blue: 0.99))
    }
    
    /// 切换折叠状态
    private func toggleCollapse() {
        withAnimation(.easeInOut(duration: 0.2)) {
            // 由于 CollapsibleBlock 是 struct，我们需要创建一个新的实例
            block = CollapsibleBlock(
                lines: block.lines,
                isCollapsed: !block.isCollapsed,
                startLineNumber: block.startLineNumber,
                endLineNumber: block.endLineNumber,
                contextInfo: block.contextInfo
            )
        }
    }
}

// MARK: - Preview

#Preview("MagicDiffPreviewView") {
    MagicDiffPreviewView()
}
