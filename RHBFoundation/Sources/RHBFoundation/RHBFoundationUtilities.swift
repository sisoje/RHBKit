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
    
    static func syncOnMain<T>(_ block: () throws -> T) rethrows -> T {
        Thread.isMainThread ?
            try block() :
            try DispatchQueue.main.sync(execute: block)
    }
}
