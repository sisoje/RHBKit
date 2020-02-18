import CoreData
import RHBFoundation

extension NSManagedObjectModel {
    static let testModel: NSManagedObjectModel = {
        let model = NSManagedObjectModel()
        model.entities = [
            {
                let desc = NSEntityDescription()
                desc.name = String(describing: TestEntity.self)
                desc.managedObjectClassName = String(reflecting: TestEntity.self)
                desc.properties = [
                    {
                        let attr = NSAttributeDescription()
                        attr.isOptional = true
                        attr.name = #keyPath(TestEntity.id)
                        attr.attributeType = .stringAttributeType
                        return attr
                    }(),
                    {
                        let attr = NSAttributeDescription()
                        attr.isOptional = true
                        attr.name = #keyPath(TestEntity.text)
                        attr.attributeType = .stringAttributeType
                        return attr
                    }()
                ]
                return desc
            }()
        ]
        return model
    }()
}
