import SwiftUI

#Preview("Xcode Icon Generator") {
    GeometryReader { geo in
        Image.makeCoffeeReelIcon(useDefaultBackground: false, size: geo.size.width * 0.8)
            .magicCentered()
    }
    .inBackgroundMint()
    .inMagicContainer(CGSize(width: 1024, height: 1024), scale: 0.5)
}
