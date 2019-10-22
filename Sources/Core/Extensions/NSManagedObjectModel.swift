import CoreData

public extension NSManagedObjectModel {
    convenience init?(name: String, in bundle: Bundle = .main) {
        guard let url = bundle.url(forResource: name, withExtension: "momd") else {
            return nil
        }
        self.init(contentsOf: url)
    }
}
