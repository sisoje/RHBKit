import Foundation

public protocol TypedPredicateProtocol: NSPredicate { associatedtype Root }
public final class CompoundTypedPredicate<Root>: NSCompoundPredicate, TypedPredicateProtocol {}
public final class ComparisonTypedPredicate<Root>: NSComparisonPredicate, TypedPredicateProtocol {}

public extension ComparisonTypedPredicate {
    convenience init<VAL>(
        _ kp: KeyPath<Root, VAL>,
        _ op: Operator,
        _ value: Any?,
        _ options: Options = [],
        _ modifier: Modifier = .direct
    ) {
        let ex1 = \Root.self == kp ? NSExpression.expressionForEvaluatedObject() : NSExpression(forKeyPath: kp)
        let ex2 = NSExpression(forConstantValue: value)
        self.init(leftExpression: ex1, rightExpression: ex2, modifier: modifier, type: op, options: options)
    }
}
