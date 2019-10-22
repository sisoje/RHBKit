import Foundation


public prefix func !(predicate: NSPredicate) -> NSPredicate {
    return NSCompoundPredicate(notPredicateWithSubpredicate: predicate)
}

public func ||(predicate1: NSPredicate, predicate2: NSPredicate) -> NSPredicate {
    return NSCompoundPredicate(orPredicateWithSubpredicates: [predicate1, predicate2])
}

public func &&(predicate1: NSPredicate, predicate2: NSPredicate) -> NSPredicate {
    return NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
}
