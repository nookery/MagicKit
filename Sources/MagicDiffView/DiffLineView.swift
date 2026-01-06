import OSLog
import SwiftUI
#if os(iOS)
    import UIKit
#endif
#if os(macOS)
    import AppKit
#endif

/// 差异视图中的单行视图
struct DiffLineView: View {
    public nonisolated static let emoji = "📄"

    let line: DiffLine
    let showLineNumbers: Bool
    let font: Font
    let codeLanguage: CodeLanguage
    let displayMode: MagicDiffViewMode
    let verbose: Bool
    let showIndicator: Bool = false

    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 0) {
            if showLineNumbers {
                lineNumberView
            }

            if showIndicator {
                indicatorView
            }

            contentView
        }
        .background(backgroundColor)
        #if os(macOS)
            .onHover { hovering in
                isHovered = hovering
            }
        #endif
            .contextMenu {
                Button(action: {
                    copyLine()
                }) {
                    Label("复制行", systemImage: "doc.on.doc")
                }

                if !line.content.isEmpty {
                    Button(action: {
                        copyContent(line.content)
                    }) {
                        Label("复制内容", systemImage: "text.cursor")
                    }
                }
            }
    }

    /// 行号视图
    private var lineNumberView: some View {
        HStack(spacing: 0) {
            switch displayMode {
            case .diff:
                lineNumberText(line.oldLineNumber, color: .secondary.opacity(0.8))
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(Color.secondary.opacity(0.1))
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
        .overlay(
            Rectangle()
                .frame(width: 1)
                .foregroundColor(Color.secondary.opacity(0.1)),
            alignment: .trailing
        )
    }

    private func lineNumberText(_ number: Int?, color: Color) -> some View {
        Text(number.map(String.init) ?? "")
            .font(font)
            .foregroundColor(color)
            .frame(width: 36, alignment: .trailing)
            .padding(.horizontal, 4)
    }

    /// 指示器视图 (+/-)
    private var indicatorView: some View {
        Text(indicatorSymbol)
            .font(font)
            .foregroundColor(.secondary)
            .frame(width: 16, alignment: .center)
    }

    private var indicatorSymbol: String {
        switch line.type {
        case .added: return "+"
        case .removed: return "-"
        default: return ""
        }
    }

    /// 内容视图
    private var contentView: some View {
        Group {
            if !line.content.isEmpty {
                if displayMode == .diff {
                    switch line.type {
                    case .added:
                        SyntaxHighlighter.highlight(
                            text: line.content,
                            rules: codeLanguage.rules,
                            highlightRanges: line.highlightRanges,
                            highlightColor: Color.green.opacity(0.3),
                            verbose: verbose
                        )
                        .font(font)
                        .foregroundColor(.black)
                        .padding(.leading, 4)
                    case .removed:
                        SyntaxHighlighter.highlight(
                            text: line.content,
                            rules: codeLanguage.rules,
                            highlightRanges: line.highlightRanges,
                            highlightColor: Color.red.opacity(0.3),
                            verbose: verbose
                        )
                        .font(font)
                        .foregroundColor(.black)
                        .padding(.leading, 4)
                    case .unchanged:
                        SyntaxHighlighter.highlight(
                            text: line.content,
                            rules: codeLanguage.rules,
                            verbose: verbose
                        )
                        .font(font)
                        .foregroundColor(.primary)
                        .padding(.leading, 4)
                    case .modified:
                        SyntaxHighlighter.highlight(
                            text: line.content,
                            rules: codeLanguage.rules,
                            verbose: verbose
                        )
                        .font(font)
                        .foregroundColor(.orange)
                        .padding(.leading, 4)
                    }
                } else {
                    SyntaxHighlighter.highlight(
                        text: line.content,
                        rules: codeLanguage.rules,
                        verbose: verbose
                    )
                    .font(font)
                    .foregroundColor(.primary)
                    .padding(.leading, 4)
                }
            } else {
                Text("")
                    .font(font)
                    .padding(.leading, 4)
            }
        }
        .frame(maxHeight: .infinity)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 2)
    }

    /// 背景颜色
    private var backgroundColor: Color {
        // if isHovered {
        //     #if os(macOS)
        //     return Color(NSColor.controlBackgroundColor).opacity(0.5)
        //     #else
        //     return Color(UIColor.secondarySystemBackground).opacity(0.5)
        //     #endif
        // }

        switch line.type {
        case .added:
            return Color.green.opacity(0.06)
        case .removed:
            return Color.red.opacity(0.06)
        case .unchanged:
            return Color.clear
        case .modified:
            return Color.orange.opacity(0.06)
        }
    }

    /// 行号区域背景颜色
    private var gutterBackgroundColor: Color {
        switch line.type {
        case .added:
            return Color.green.opacity(0.15)
        case .removed:
            return Color.red.opacity(0.15)
        case .unchanged:
            return Color(red: 0.96, green: 0.97, blue: 0.99)
        case .modified:
            return Color.orange.opacity(0.15)
        }
    }

    /// 复制整行
    private func copyLine() {
        if !line.content.isEmpty {
            #if os(macOS)
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(line.content, forType: .string)
            #else
                UIPasteboard.general.string = line.content
            #endif

            if verbose {
                os_log("复制行: \(line.content)")
            }
        }
    }

    /// 复制内容
    private func copyContent(_ content: String) {
        #if os(macOS)
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(content, forType: .string)
        #else
            UIPasteboard.general.string = content
        #endif

        if verbose {
            os_log("复制内容: \(content)")
        }
    }

    init(
        line: DiffLine,
        showLineNumbers: Bool,
        font: Font = .system(.body, design: .monospaced),
        codeLanguage: CodeLanguage = .swift,
        displayMode: MagicDiffViewMode = .diff,
        verbose: Bool = false
    ) {
        self.line = line
        self.showLineNumbers = showLineNumbers
        self.font = font
        self.codeLanguage = codeLanguage
        self.displayMode = displayMode
        self.verbose = verbose
    }
}

// MARK: - Preview

#if DEBUG
    #Preview("MagicDiffPreviewView") {
        MagicDiffPreviewView()
    }

    #Preview {
        VStack(alignment: .leading, spacing: 12) {
            let unchanged = DiffLine(
                content: "print(\"Hello World\")",
                type: .unchanged,
                oldLineNumber: 1,
                newLineNumber: 1
            )
            let removed = DiffLine(
                content: "print(\"Old Only\")",
                type: .removed,
                oldLineNumber: 2,
                newLineNumber: nil
            )
            let added = DiffLine(
                content: "print(\"New Only\")",
                type: .added,
                oldLineNumber: nil,
                newLineNumber: 3
            )

            DiffLineView(
                line: unchanged,
                showLineNumbers: true,
                font: .system(.body, design: .monospaced),
                codeLanguage: .swift,
                displayMode: .diff,
                verbose: true
            )

            DiffLineView(
                line: removed,
                showLineNumbers: true,
                font: .system(.body, design: .monospaced),
                codeLanguage: .swift,
                displayMode: .original,
                verbose: true
            )

            DiffLineView(
                line: added,
                showLineNumbers: true,
                font: .system(.body, design: .monospaced),
                codeLanguage: .swift,
                displayMode: .modified,
                verbose: true
            )
        }
        .padding()
    }
#endif
