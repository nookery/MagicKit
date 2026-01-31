import SwiftUI

/// 主题切换按钮组件
struct ThemeToggleButton: View {
    @Binding var isDarkMode: Bool
    
    var body: some View {
        Button(action: {
            isDarkMode.toggle()
        }) {
            Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                .padding(4)
        }
        .buttonStyle(.bordered)
        .clipShape(Circle())
    }
}
