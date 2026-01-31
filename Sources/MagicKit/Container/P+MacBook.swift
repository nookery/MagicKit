#if DEBUG
    import SwiftUI

    #Preview("MacBook 13 - 100%") {
        Text("Hello, World!")
            .font(.system(size: 400))
            .magicCentered()
            .background(.indigo.opacity(0.3))
            .inMagicContainer(.macBook13, scale: 0.2)
    }

    #Preview("MacBook 13 - 20%") {
        Text("Hello, World!")
            .font(.system(size: 40))
            .magicCentered()
            .background(.indigo.opacity(0.3))
            .inMagicContainer(.macBook13_20Percent)
    }

    #Preview("MacBook 13 - 10%") {
        Text("Hello, World!")
            .font(.system(size: 20))
            .magicCentered()
            .background(.indigo.opacity(0.3))
            .inMagicContainer(.macBook13_10Percent)
    }

    #Preview("MacBook 13 - 缩放示例") {
        Text("Hello, World!")
            .font(.system(size: 200))
            .magicCentered()
            .background(.green.opacity(0.3))
            .inMagicContainer(.macBook13, scale: 0.3)
    }
#endif
