import SwiftUI

/// 差异视图中的行指示器视图
struct DiffLineIndicatorView: View {
    let line: DiffLine
    let font: Font

    var body: some View {
        Text(indicatorSymbol)
            .font(font)
            .foregroundColor(.secondary)
            .frame(width: 16, alignment: .center)
    }

    /// 根据行类型返回对应的指示器符号
    private var indicatorSymbol: String {
        switch line.type {
        case .added: return "+"
        case .removed: return "-"
        default: return ""
        }
    }
}
