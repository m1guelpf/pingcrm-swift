import Leaf
import Vapor
import Foundation

public extension Application {
    var vite: Vite {
        .init(application: self)
    }

    struct Vite {
        public let application: Application

        var publicPath: String {
            application.directory.publicDirectory
        }

        var isRunningHot: Bool {
            return FileManager.default.fileExists(atPath: "\(publicPath)/hot")
        }

        public func setup() {
            application.views.use(.leaf)
            application.middleware.use(FileMiddleware(publicDirectory: application.directory.publicDirectory))

            application.leaf.tags["vite"] = ViteTag(vite: self)
            application.leaf.tags["viteReactRefresh"] = ViteReactRefreshTag(vite: self)
        }

        public func asset(path: String) throws -> String {
            if isRunningHot {
                return try hotAsset(path: path)
            }

            let chunk = try self.chunk(manifest: manifest(), path: path)

            return "/build/\(chunk.file)"
        }

        public func content(asset path: String) throws -> Data {
            let chunk = try self.chunk(manifest: manifest(), path: path)

            let file = try Result { try Data(contentsOf: URL(fileURLWithPath: "\(publicPath)/build/\(chunk.file)")) }
                .mapError { _ in Error.missingEntry(path: path) }
                .get()

            return file
        }

        public func reactRefresh() throws -> String? {
            if !isRunningHot {
                return nil
            }

            return try """
            <script type="module">
                import RefreshRuntime from '\(hotAsset(path: "@react-refresh"))'
                RefreshRuntime.injectIntoGlobalHook(window)
                window.$RefreshReg$ = () => {}
                window.$RefreshSig$ = () => (type) => type
                window.__vite_plugin_react_preamble_installed__ = true
            </script>
            """
        }

        private func tags(for asset: String) throws -> String {
            try tags(for: [asset])
        }

        private func tags(for assets: [String]) throws -> String {
            if isRunningHot {
                return try (["@vite/client"] + assets).map { asset in
                    try self.makeTagForChunk(src: asset, url: self.hotAsset(path: asset))
                }.joined(separator: "")
            }

            let manifest = try self.manifest()
            var tags: [String] = []

            for asset in assets {
                let chunk = try self.chunk(manifest: manifest, path: asset)

                tags.append(makeTagForChunk(src: asset, url: "/build/\(chunk.file)"))
            }

            let (stylesheets, scripts): ([String], [String]) = tags.reduce(into: ([], [])) { result, tag in
                if tag.contains("rel=\"stylesheet\"") {
                    result.0.append(tag)
                } else {
                    result.1.append(tag)
                }
            }

            return stylesheets.joined(separator: "") + scripts.joined(separator: "")
        }

        private func makeTagForChunk(src _: String, url: String) -> String {
            if isCssPath(url) {
                return makeStylesheetTag(url: url)
            }

            return makeScriptTag(url: url)
        }

        private func isCssPath(_ path: String) -> Bool {
            return path.range(of: #"\.(css|less|sass|scss|styl|stylus|pcss|postcss)$"#, options: .regularExpression) != nil
        }

        private func makeScriptTag(url: String) -> String {
            return makeScriptTag(url: url, attrs: [:])
        }

        private func makeScriptTag(url: String, attrs: [String: String]) -> String {
            let attributes = ["type": "module", "src": url]
                .merging(attrs) { _, new in new }
                .map { key, value in "\(key)=\"\(value)\"" }
                .joined(separator: " ")

            return "<script \(attributes)></script>"
        }

        private func makeStylesheetTag(url: String) -> String {
            return makeStylesheetTag(url: url, attrs: [:])
        }

        private func makeStylesheetTag(url: String, attrs: [String: String]) -> String {
            let attributes = ["rel": "stylesheet", "href": url]
                .merging(attrs) { _, new in new }
                .map { key, value in "\(key)=\"\(value)\"" }
                .joined(separator: " ")

            return "<link \(attributes) />"
        }

        private func hotAsset(path asset: String) throws -> String {
            let url = try String(contentsOfFile: "\(publicPath)/hot").trimmingCharacters(in: .whitespacesAndNewlines)

            return "\(url)/\(asset)"
        }

        private func chunk(manifest: [String: ManifestEntry], path: String) throws -> ManifestEntry {
            guard let chunk = manifest[path] else {
                throw Error.missingEntry(path: path)
            }

            return chunk
        }

        private func manifest() throws -> [String: ManifestEntry] {
            let data = try Result { try Data(contentsOf: URL(fileURLWithPath: "\(publicPath)/build/manifest.json")) }
                .mapError { _ in Error.missingManifest(path: "\(publicPath)/build/manifest.json") }
                .get()

            return try JSONDecoder().decode([String: ManifestEntry].self, from: data)
        }

        struct ViteTag: UnsafeUnescapedLeafTag {
            let vite: Vite

            func render(_ ctx: LeafContext) throws -> LeafData {
                let paths = ctx.parameters.compactMap { $0.string }

                return try LeafData.string(vite.tags(for: paths))
            }
        }

        struct ViteReactRefreshTag: UnsafeUnescapedLeafTag {
            let vite: Vite

            func render(_: LeafContext) throws -> LeafData {
                return try LeafData.string(vite.reactRefresh())
            }
        }

        enum Error: Swift.Error, DebuggableError {
            case leafMissingPathParameter
            case missingEntry(path: String)
            case missingManifest(path: String)

            static var readableName: String {
                "Vite Error"
            }

            public var identifier: String {
                switch self {
                    case .leafMissingPathParameter:
                        return "missingPathParameter"

                    case .missingManifest:
                        return "missingManifest"
                    case .missingEntry:
                        return "missingEntry"
                }
            }

            var reason: String {
                switch self {
                    case .leafMissingPathParameter:
                        return "The `vite` tag requires a path parameter."

                    case .missingManifest:
                        return "The Vite manifest file is missing."
                    case let .missingEntry(path):
                        return "The requested file (\(path)) is missing from the Vite manifest."
                }
            }

            var suggestedFixes: [String] {
                switch self {
                    case .leafMissingPathParameter:
                        return ["Ensure that the `vite` tag is called with a path parameter."]
                    case .missingManifest:
                        return ["Ensure that Vite's development server is running or that the production build has been generated."]
                    case .missingEntry:
                        return ["Ensure that the requested file is part of the Vite manifest."]
                }
            }
        }

        struct ManifestEntry: Decodable {
            let file: String
            let name: String
            let src: String
            let css: String?
            let isEntry: Bool?
            let imports: [String]?
            let isDynamicEntry: Bool?
            let dynamicImports: [String]?
        }
    }
}
