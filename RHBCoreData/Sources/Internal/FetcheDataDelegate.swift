//
//  File.swift
//  
//
//  Created by Lazar Otasevic on 2/19/20.
//

import CoreData

final class FetcheDataDelegate<T: NSFetchRequestResult>: NSObject, NSFetchedResultsControllerDelegate {
    weak var fetchedData: FetchedData<T>?

    func controllerDidChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        fetchedData?.didChange?()
    }

    func controllerWillChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        fetchedData?.willChange?()
    }

    func controller(_: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        fetchedData?.didChangeObject[type]?(anObject as! T, indexPath, newIndexPath)
    }

    func controller(_: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        fetchedData?.sectionIndexTitle?(sectionName)
    }

    func controller(_: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        fetchedData?.didChangeSection[type]?(sectionInfo, sectionIndex)
    }
}
