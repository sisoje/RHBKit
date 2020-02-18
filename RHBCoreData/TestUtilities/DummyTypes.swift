import Foundation

@objcMembers
class DummyTypes: NSObject {
    @NSManaged var bool: Bool
    @NSManaged var decimal: Decimal
    @NSManaged var int: Int
    @NSManaged var double: Double
    @NSManaged var url: URL
    @NSManaged var uuid: UUID
    @NSManaged var date: Date
    @NSManaged var string: String
    @NSManaged var timeinterval: TimeInterval
    @NSManaged var data: Data
    @NSManaged var orderedset: NSOrderedSet
    @NSManaged var set: Set<NSObject>
    @NSManaged var array: [NSObject]
    @NSManaged var dictionary: [NSObject: NSObject]
}

extension DummyTypes {
    static let typesByName: [String: String] = Dictionary(uniqueKeysWithValues: objc_property_t.propertyList(DummyTypes.self).map { ($0.propertyName(), $0.typeInfo()) })

    static func matchType(name: String, info: String) -> Bool {
        let myInfo = typesByName[name]!
        return myInfo.split(separator: ",")[0] == info.split(separator: ",")[0]
    }
}
