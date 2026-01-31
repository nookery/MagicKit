import SwiftUI

extension MagicContainer {
    var themeToggleButton: some View {
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
