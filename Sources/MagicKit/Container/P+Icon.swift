#if DEBUG
    import SwiftUI

    #Preview("Xcode Icon Generator") {
        Text("🎨")
            .font(.system(size: 400))
            .frame(width: 1024, height: 1024)
            .background(
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .magicCentered()
            .inMagicContainer(CGSize(width: 1024, height: 1024), scale: 0.5)
    }
#endif
