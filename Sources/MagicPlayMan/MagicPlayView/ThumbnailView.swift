import MagicCore
import OSLog
import SwiftUI

struct ThumbnailView: View, SuperLog {
    nonisolated static let emoji = "🖥️"

    private let url: URL?
    private let verbose: Bool
    private let defaultImage: Image?
    private let defaultView: AnyView?
    private let preferredThumbnailSize: CGFloat = 512 // 或其他合适的尺寸
    @State private var loadedArtwork: Image?

    init(
        url: URL? = nil,
        verbose: Bool = false,
        defaultImage: Image? = nil
    ) {
        if verbose {
            os_log("\(Self.t) Make ThumbnailView with defaultImage")
        }
        self.url = url
        self.verbose = verbose
        self.defaultImage = defaultImage
        self.defaultView = nil
    }

    init(
        url: URL? = nil,
        verbose: Bool = false,
        defaultImage: Image
    ) {
        if verbose {
            os_log("\(Self.t) Make ThumbnailView with defaultImage")
        }
        self.url = url
        self.verbose = verbose
        self.defaultImage = defaultImage
        self.defaultView = nil
    }

    init<Content: View>(
        url: URL? = nil,
        verbose: Bool = false,
        @ViewBuilder defaultView: () -> Content
    ) {
        if verbose {
            os_log("\(Self.t) Make ThumbnailView with defaultView")
        }
        self.url = url
        self.verbose = verbose
        self.defaultImage = nil
        self.defaultView = AnyView(defaultView())
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
                        if let defaultImage = defaultImage {
                            defaultImage
                                .font(.system(size: min(geo.size.width, geo.size.height) * 0.3))
                                .foregroundStyle(.secondary)
                                .onAppear {
                                    if verbose {
                                        os_log("\(self.t) artwork default (image)")
                                    }
                                }
                        } else if let defaultView = defaultView {
                            defaultView
                                .onAppear {
                                    if verbose {
                                        os_log("\(self.t) artwork default (view)")
                                    }
                                }
                        } else {
                            Image(systemName: (url == nil) ? .iconDoc : .iconMusic)
                                .font(.system(size: min(geo.size.width, geo.size.height) * 0.3))
                                .foregroundStyle(.secondary)
                                .onAppear {
                                    if verbose {
                                        os_log("\(self.t) artwork default (builtin)")
                                    }
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
                            useDefaultIcon: false,
                            verbose: self.verbose,
                            reason: "MagicPlayMan." + self.className + ".task"
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
}

#Preview("Success (MP3)") {
    ThumbnailView(url: .sample_web_mp3_kennedy, defaultImage: Image(systemName: .iconMusic))
        .frame(height: 500)
        .frame(width: 500)
}

#Preview("Fallback (Invalid URL)") {
    ThumbnailView(url: .sample_invalid_url, defaultView: {
        VStack(spacing: 12) {
            Image(systemName: .iconDoc)
            Text("No Artwork")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    })
    .frame(height: 500)
    .frame(width: 500)
}

#Preview("MagicPlayMan") {
    MagicPlayMan.PreviewView()
}
