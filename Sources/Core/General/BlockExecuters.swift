import Foundation

let isdebug: Bool = {
    #if DEBUG
    return true
    #else
    return false
    #endif
}()

let issimulator = TARGET_OS_SIMULATOR != 0

public protocol ExecuterProtocol {
    func execute(_ block: () -> Void)
    func wrap<T>(object: T) -> T
}

public extension ExecuterProtocol {
    func execute(_ block: () -> Void) {
        block()
    }
    func wrap<T>(object: T) -> T {
        return object
    }
}

public class Executer: ExecuterProtocol {
    public static let debug = isdebug ? Executer() : nil
    public static let release = isdebug ? nil : Executer()
    public static let simulator = issimulator ? Executer() : nil
    public static let device = issimulator ? nil : Executer()
}
