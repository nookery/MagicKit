import MagicCore
import OSLog
import SwiftUI

struct ThumbnailView: View, SuperLog {
    nonisolated static let emoji = "🖥️"

    let url: URL?
    let verbose: Bool
    var defaultImage: Image = .imageDocument
    private let preferredThumbnailSize: CGFloat = 512 // 或其他合适的尺寸
    @State private var loadedArtwork: Image?

    init(url: URL? = nil, verbose: Bool = false, defaultImage: Image = .imageDocument) {
        self.url = url
        self.verbose = verbose
        self.defaultImage = defaultImage
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 20) {
                // 封面图
                Group {
                    if let loadedArtwork = loadedArtwork {
                        loadedArtwork
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: min(geo.size.width - 40, geo.size.height - 40),
                                height: min(geo.size.width - 40, geo.size.height - 40)
                            )
                            .onAppear {
                                if verbose {
                                    os_log("\(self.t) artwork loaded")
                                }
                            }
                    } else {
                        defaultImage
                            .font(.system(size: min(geo.size.width, geo.size.height) * 0.3))
                            .foregroundStyle(.secondary)
                            .onAppear {
                                if verbose {
                                    os_log("\(self.t) artwork default")
                                }
                            }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .task(id: url) {
                if let url = url {
                    do {
                        loadedArtwork = try await url.thumbnail(
                            size: CGSize(
                                width: preferredThumbnailSize,
                                height: preferredThumbnailSize
                            ),
                            verbose: true, reason: "MagicPlayMan." + self.className + ".task"
                        )
                    } catch {
                        loadedArtwork = nil
                    }
                } else {
                    loadedArtwork = nil
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("ThumbnailView") {
    ThumbnailView(defaultImage: Image(systemName: .iconDoc))
        .frame(height: 500)
        .frame(width: 500)
        .inMagicContainer(containerHeight: 600)
}

#Preview("Success (MP3)") {
    ThumbnailView(url: .sample_web_mp3_kennedy, defaultImage: Image(systemName: .iconMusic))
        .frame(height: 500)
        .frame(width: 500)
        .inMagicContainer(containerHeight: 600)
}

#Preview("Fallback (Invalid URL)") {
    ThumbnailView(url: .sample_invalid_url, defaultImage: Image(systemName: .iconDoc))
        .frame(height: 500)
        .frame(width: 500)
        .inMagicContainer(containerHeight: 600)
}

#Preview("MagicPlayMan") {
    MagicPlayMan.PreviewView()
        .inMagicContainer(containerHeight: 600)
}
