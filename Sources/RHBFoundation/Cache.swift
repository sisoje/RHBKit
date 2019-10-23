import Foundation

open class Cache<H: Hashable, V: AnyObject> {
    public let nsCache = NSCache<AnyObject, V>()
    public init() {}
}

public extension Cache {
    subscript(_ h: H) -> V? {
        get {
            nsCache.object(forKey: h as AnyObject)
        }
        set {
            if let v = newValue {
                nsCache.setObject(v, forKey: h as AnyObject)
            } else {
                nsCache.removeObject(forKey: h as AnyObject)
            }
        }
    }
}
