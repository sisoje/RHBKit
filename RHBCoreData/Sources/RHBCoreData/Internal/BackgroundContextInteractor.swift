import CoreData

final class BackgroundContextInteractor {
    private var context: NSManagedObjectContext?

    init(_ context: NSManagedObjectContext) {
        self.context = context
    }

    deinit {
        context.map {
            context = nil
            $0.performAndWait {}
        }
    }
}

extension BackgroundContextInteractor {
    func performTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        context?.perform { [weak self] in
            self?.context.map {
                block($0)
            }
        }
    }
}
