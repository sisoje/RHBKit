import Foundation

public final class StringSortDescriptor: NSSortDescriptor {
    public init<T>(keyPath: KeyPath<T, String?>, ascending: Bool, comparatorType: StringComparatorType) {
        super.init(key: NSExpression(forKeyPath: keyPath).keyPath, ascending: ascending, selector: comparatorType.selector)
    }

    public init<T>(keyPath: KeyPath<T, String>, ascending: Bool, comparatorType: StringComparatorType) {
        super.init(key: NSExpression(forKeyPath: keyPath).keyPath, ascending: ascending, selector: comparatorType.selector)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
