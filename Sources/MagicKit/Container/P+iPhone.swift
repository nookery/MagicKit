#if DEBUG
    import SwiftUI

    #Preview("iPhone") {
        Text("Hello, World!")
            .magicCentered()
            .background(.orange.opacity(0.3))
            .inMagicContainer(.iPhone)
    }

    #Preview("iPhoneSE") {
        Text("Hello, World!")
            .magicCentered()
            .background(.red.opacity(0.3))
            .inMagicContainer(.iPhoneSE)
    }

    #Preview("iPhone 6.5\"") {
        Text("Hello, World!")
            .font(.system(size: 200))
            .magicCentered()
            .background(.purple.opacity(0.3))
            .inMagicContainer(.iPhone65, scale: 0.5)
    }
#endif
