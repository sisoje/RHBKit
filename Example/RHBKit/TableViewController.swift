import UIKit
import RHBKit
import CoreData

extension CDObject: MutableProtocol, ManagedObjectProtocol {}
extension NSFetchRequest: MutableProtocol {}

let cdFetchRequest = CDObject.selfFetchRequest().mutate {
    $0.sortDescriptors = [NSSortDescriptor(key: #keyPath(CDObject.value), ascending: true)]
}

class TableViewController : UITableViewController {

    var deiniters:[Deiniter] = []
    let tableViewUpdater = TableViewBackgroundFetchedUpdater()

    public var dataStack: DataStack?

    var tableViewDataSource: TableViewDataSource? {
        didSet {
            tableView.dataSource = tableViewDataSource
            tableViewDataSource?.fetchedData.controller.delegate = tableViewUpdater
            tableViewUpdater.tableView = tableView
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let dataloadViewController = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController as? DataLoadViewController {
            dataStack = DataStack(dataloadViewController.container)
        }

        dataStack?.backgroundFetch(cdFetchRequest) { [weak self] controller, mainContext in
            self?.tableViewDataSource = TableViewDataSource(controller, mainContext)
            self?.tableView.reloadData()
        }

        let timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak dataStack = dataStack] _ in
            dataStack?.saveDataWork { context in
                let id = Int64(arc4random() % 32)
                let request = CDObject.selfFetchRequest().mutate {
                    $0.predicate = \CDObject.value == id
                }
                if let object = (try! context.fetch(request)).first {
                    context.delete(object)
                } else {
                    CDObject(context: context).mutate {
                        $0.value = id
                        $0.colorRef = Int32(arc4random() % (1<<24))
                    }
                }
            }
        }
        deiniters.append {
            timer.invalidate()
        }
    }
}
