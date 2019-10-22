import UIKit
import CoreData

open class TableViewFetchedDataSource<TDATA: FetchedDataProtocol>: NSObject, UITableViewDataSource {

    public typealias T = TDATA.T

    public let fetchedData: TDATA

    public init(_ fetchedData: TDATA) {
        self.fetchedData = fetchedData
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedData.objectsIn(section: section)
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedData.sections
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellFor(tableView: tableView, indexPath: indexPath, object: fetchedData[indexPath])
    }

    open func cellFor(tableView: UITableView, indexPath: IndexPath, object: T) -> UITableViewCell {
        assertionFailure("need implementation")
        return UITableViewCell()
    }
}

open class TableViewBackgroundFetchedDataSource<T: NSManagedObject>: TableViewFetchedDataSource<BackgroundFetchedData<T>> {

    public init(_ controller: NSFetchedResultsController<T>, _ mainContext: NSManagedObjectContext) {
        super.init(BackgroundFetchedData(controller, mainContext))
    }
}

open class TableViewMainFetchedDataSource<T: NSManagedObject>: TableViewFetchedDataSource<MainFetchedData<T>> {

    public init(_ controller: NSFetchedResultsController<T>) {
        super.init(MainFetchedData(controller))
    }
}
