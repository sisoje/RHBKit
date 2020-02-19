//
//  File.swift
//  
//
//  Created by Lazar Otasevic on 2/19/20.
//

import CoreData

public struct BacgroundReader {
    private let backgroundContextInteractor: BackgroundContextInteractor
}

public extension BacgroundReader {
    init(container: NSPersistentContainer) {
        let context = container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        self.init(backgroundContextInteractor: BackgroundContextInteractor(context))
    }

    func read(errorBlock: @escaping (Error?) -> Void, _ taskBlock: @escaping (NSManagedObjectContext) throws -> Void) {
        backgroundContextInteractor.performTask { context in
            var resultError: Error?
            do {
                try taskBlock(context)
            } catch {
                resultError = error
            }
            DispatchQueue.main.async {
                errorBlock(resultError)
            }
        }
    }
}
