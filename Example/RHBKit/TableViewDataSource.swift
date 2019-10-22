import UIKit
import RHBKit


class TableViewDataSource: TableViewBackgroundFetchedDataSource<CDObject> {

    override func cellFor(tableView: UITableView, indexPath: IndexPath, object: CDObject) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: self.description)
        cell.textLabel?.text = object.value.description
        cell.backgroundColor = UIColor(colorReference: Int(object.colorRef))
        return cell
    }
}
