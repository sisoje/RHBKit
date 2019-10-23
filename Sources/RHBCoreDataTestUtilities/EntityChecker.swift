import CoreData
import RHBFoundation
import XCTest

// MARK: - Public

public class EntityChecker {
    let entityDescription: NSEntityDescription
    public init(entityDescription: NSEntityDescription) {
        self.entityDescription = entityDescription
    }
}

public extension EntityChecker {
    func checkEntity() {
        XCTAssert(Int.bitWidth == 64, "This checker is for 64-bit platforms only")
        checkForUnmatchedProperties()
        checkIfTypeFromCoreDataAttributesMatchesTypeInClass()
    }
}

extension NSManagedObject {
    static func propertyList() -> [objc_property_t] {
        guard self != NSManagedObject.self else {
            return []
        }
        return objc_property_t.propertyList(self) + (superclass() as! NSManagedObject.Type).propertyList()
    }
}

extension EntityChecker {
    var classPropertiesByName: [String: objc_property_t] {
        let classType = NSClassFromString(entityDescription.managedObjectClassName!)! as! NSManagedObject.Type
        return Dictionary(uniqueKeysWithValues: classType.propertyList().map { ($0.propertyName(), $0) })
    }

    func checkForUnmatchedProperties() {
        let set1 = Set(classPropertiesByName.keys)
        let set2 = Set(entityDescription.propertiesByName.keys)
        XCTAssert(set1 == set2, "Names must match for entity \(entityDescription.name!) difference is: \(set1.symmetricDifference(set2))")
    }

    func checkValueTypeNotOptional(_ attributeDescription: NSAttributeDescription, _ typeInfoInClass: String) {
        if attributeDescription.isOptional {
            XCTAssert(typeInfoInClass.hasSuffix(",C"), "Value types should not be optional in entity: \(entityDescription.name!) property: \(attributeDescription.name)")
        }
    }

    func checkIfTypeFromCoreDataMatchesTypeInClass(_ attributeDescription: NSAttributeDescription, _ typeInfoInClass: String) {
        switch attributeDescription.attributeType {
        case .floatAttributeType:
            fallthrough
        case .integer16AttributeType:
            fallthrough
        case .integer32AttributeType:
            XCTFail("Should use 64-bit types in entity: \(entityDescription.name!) property: \(attributeDescription.name) ")
        case .integer64AttributeType:
            XCTAssert(DummyTypes.matchType(name: "int", info: typeInfoInClass), "Should use Int in entity: \(entityDescription.name!) property: \(attributeDescription.name) type in class: \(typeInfoInClass)")
        case .doubleAttributeType:
            XCTAssert(DummyTypes.matchType(name: "double", info: typeInfoInClass), "Should use Double in entity: \(entityDescription.name!) property: \(attributeDescription.name) type in class: \(typeInfoInClass)")
        case .booleanAttributeType:
            XCTAssert(DummyTypes.matchType(name: "bool", info: typeInfoInClass), "Should use Bool in entity: \(entityDescription.name!) property: \(attributeDescription.name) type in class: \(typeInfoInClass)")
        case .UUIDAttributeType:
            XCTAssert(DummyTypes.matchType(name: "uuid", info: typeInfoInClass), "Should use UUID in entity: \(entityDescription.name!) property: \(attributeDescription.name) type in class: \(typeInfoInClass)")
        case .stringAttributeType:
            XCTAssert(DummyTypes.matchType(name: "string", info: typeInfoInClass), "Should use String in entity: \(entityDescription.name!) property: \(attributeDescription.name) type in class: \(typeInfoInClass)")
        case .URIAttributeType:
            XCTAssert(DummyTypes.matchType(name: "url", info: typeInfoInClass), "Should use Url in entity: \(entityDescription.name!) property: \(attributeDescription.name) type in class: \(typeInfoInClass)")
        case .dateAttributeType:
            XCTAssert(DummyTypes.matchType(name: "date", info: typeInfoInClass) || DummyTypes.matchType(name: "timeinterval", info: typeInfoInClass), "Should use Date or TimeInterval in entity: \(entityDescription.name!) property: \(attributeDescription.name) type in class: \(typeInfoInClass)")
        case .binaryDataAttributeType:
            XCTAssert(DummyTypes.matchType(name: "data", info: typeInfoInClass), "Should use Data in entity: \(entityDescription.name!) property: \(attributeDescription.name) type in class: \(typeInfoInClass)")
        case .transformableAttributeType:
            XCTAssertNotNil(attributeDescription.attributeValueClassName, "No custom class set in entity: \(entityDescription.name!) property: \(attributeDescription.name) type in class: \(typeInfoInClass)")
            XCTAssert(DummyTypes.matchType(name: "set", info: typeInfoInClass) || DummyTypes.matchType(name: "array", info: typeInfoInClass) || DummyTypes.matchType(name: "dictionary", info: typeInfoInClass), "Should use collection custom class in entity: \(entityDescription.name!) property: \(attributeDescription.name) type in class: \(typeInfoInClass)")
        case .decimalAttributeType:
            XCTAssert(DummyTypes.matchType(name: "decimal", info: typeInfoInClass), "Should use Decimal in entity: \(entityDescription.name!) property: \(attributeDescription.name) type in class: \(typeInfoInClass)")
        case .objectIDAttributeType:
            XCTFail("Object ID can not be used in core data in entity: \(entityDescription.name!) property: \(attributeDescription.name)")
        case .undefinedAttributeType:
            XCTFail("Undefined type in entity: \(entityDescription.name!) property: \(attributeDescription.name)")
        @unknown default:
            XCTFail("New type needs testing in entity: \(entityDescription.name!) property: \(attributeDescription.name) type in coredata: \(attributeDescription.attributeValueClassName!)")
        }
    }

    func checkIfTypeFromCoreDataAttributesMatchesTypeInClass() {
        entityDescription.attributesByName.values.forEach { attributeDescription in
            if let propertyTypeInfo = classPropertiesByName[attributeDescription.name]?.typeInfo() {
                checkValueTypeNotOptional(attributeDescription, propertyTypeInfo)
                checkIfTypeFromCoreDataMatchesTypeInClass(attributeDescription, propertyTypeInfo)
            }
        }
    }
}

public extension NSManagedObjectModel {
    func chechEntities() {
        entities.forEach {
            EntityChecker(entityDescription: $0).checkEntity()
        }
    }
}
