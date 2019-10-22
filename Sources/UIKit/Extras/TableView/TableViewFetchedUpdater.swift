import UIKit
import CoreData

public class TableViewMainFetchedUpdater: NSObject, NSFetchedResultsControllerDelegate {
    
    public weak var tableView: UITableView?
    public var rowAnimations: [NSFetchedResultsChangeType: UITableViewRowAnimation]?
    public var sectionAnimations: [NSFetchedResultsChangeType: UITableViewRowAnimation]?

    open func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        let animation = rowAnimations?[type] ?? .automatic

        switch type {
        case .insert:
            tableView?.insertRows(at: [newIndexPath!], with: animation)
        case .delete:
            tableView?.deleteRows(at: [indexPath!], with: animation)
        case .move :
            tableView?.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            tableView?.reloadRows(at: [indexPath!], with: animation)
        }
    }
    
    open func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let animation = sectionAnimations?[type] ?? .automatic
        let indexSet = IndexSet(integer: sectionIndex)

        switch type {
        case .delete:
            tableView?.deleteSections(indexSet, with: animation)
        case .insert:
            tableView?.insertSections(indexSet, with: animation)
        case .update:
            tableView?.reloadSections(indexSet, with: animation)
        case .move:
            assertionFailure()
        }
    }

    open func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
    }

    open func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
    }
}

public final class TableViewBackgroundFetchedUpdater: TableViewMainFetchedUpdater {

    override public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            super.controllerWillChangeContent(controller)
        }
    }

    override public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.sync {
            super.controllerDidChangeContent(controller)
        }
    }

    override public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        DispatchQueue.main.async {
            super.controller(controller, didChange: anObject, at: indexPath, for: type, newIndexPath: newIndexPath)
        }
    }

    override public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        DispatchQueue.main.async {
            super.controller(controller, didChange: sectionInfo, atSectionIndex: sectionIndex, for: type)
        }
    }
}
