//
//  File.swift
//  
//
//  Created by Lazar Otasevic on 2/19/20.
//

import CoreData

public struct BacgroundWriter {
    private let backgroundContextInteractor: BackgroundContextInteractor
}

public extension BacgroundWriter {
    init(container: NSPersistentContainer) {
        let context = container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = false
        self.init(backgroundContextInteractor: BackgroundContextInteractor(context))
    }

    func write(errorBlock: @escaping (Error?) -> Void, _ taskBlock: @escaping (NSManagedObjectContext) throws -> Void) {
        backgroundContextInteractor.performTask { context in
            context.reset()
            defer { context.reset() }
            var resultError: Error?
            do {
                try taskBlock(context)
                try context.saveChanges()
            } catch {
                resultError = error
            }
            DispatchQueue.main.async {
                errorBlock(resultError)
            }
        }
    }
}
