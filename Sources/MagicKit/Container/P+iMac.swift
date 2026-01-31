#if DEBUG
    import SwiftUI

    #Preview("iMac 27 - 100%") {
        Text("Hello, World!")
            .font(.system(size: 400))
            .magicCentered()
            .background(.indigo.opacity(0.3))
            .inMagicContainer(.iMac27)
    }

    #Preview("iMac 27 - 20%") {
        Text("Hello, World!")
            .padding()
            .inMagicContainer(.iMac27_20Percent)
    }

    #Preview("iMac 27 - 10%") {
        Text("Hello, World!")
            .padding()
            .inMagicContainer(.iMac27_10Percent)
    }

    #Preview("iMac 27 - 缩放") {
        Text("Hello, World!")
            .font(.system(size: 400))
            .magicCentered()
            .background(.indigo.opacity(0.3))
            .inMagicContainer(.iMac27, scale: 0.2)
    }
#endif
