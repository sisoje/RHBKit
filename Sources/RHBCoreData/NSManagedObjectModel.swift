import CoreData

public extension NSManagedObjectModel {
    convenience init?(modelDocumentName: String, bundle: Bundle = .main) {
        guard let url = bundle.url(forResource: modelDocumentName, withExtension: "momd") else {
            return nil
        }
        self.init(contentsOf: url)
    }
}
