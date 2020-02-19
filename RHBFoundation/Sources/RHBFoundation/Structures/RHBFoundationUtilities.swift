import Foundation

public enum RHBFoundationUtilities {}

public extension RHBFoundationUtilities {
    static var isDebug: Bool {
        var b = false
        assert({ b = true }() == ())
        return b
    }

    static var isSimulator: Bool {
        TARGET_OS_SIMULATOR != 0
    }

    static var documentDirectoryUrl: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    static var temporaryDirectoryUrl: URL {
        FileManager.default.temporaryDirectory
    }
}
