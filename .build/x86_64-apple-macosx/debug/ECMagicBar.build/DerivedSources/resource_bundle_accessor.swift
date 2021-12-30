import class Foundation.Bundle

extension Foundation.Bundle {
    static var module: Bundle = {
        let mainPath = Bundle.main.bundleURL.appendingPathComponent("ECMagicBar_ECMagicBar.bundle").path
        let buildPath = "/Users/eduardcalero/Documents/Libraries/ECMagicBar/.build/x86_64-apple-macosx/debug/ECMagicBar_ECMagicBar.bundle"

        let preferredBundle = Bundle(path: mainPath)

        guard let bundle = preferredBundle != nil ? preferredBundle : Bundle(path: buildPath) else {
            fatalError("could not load resource bundle: from \(mainPath) or \(buildPath)")
        }

        return bundle
    }()
}