import Foundation

public func == <E: Equatable, R, K: KeyPath<R, E>>(kp: K, value: E) -> ComparisonTypedPredicate<R> {
    ComparisonTypedPredicate(kp, .equalTo, value)
}

public func != <E: Equatable, R, K: KeyPath<R, E>>(kp: K, value: E) -> ComparisonTypedPredicate<R> {
    ComparisonTypedPredicate(kp, .notEqualTo, value)
}

public func === <S: Sequence, R, K: KeyPath<R, S.Element>>(kp: K, values: S) -> ComparisonTypedPredicate<R> where S.Element: Equatable {
    ComparisonTypedPredicate(kp, .in, values)
}

// MARK: - non optional

public func > <C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> ComparisonTypedPredicate<R> {
    ComparisonTypedPredicate(kp, .greaterThan, value)
}

public func < <C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> ComparisonTypedPredicate<R> {
    ComparisonTypedPredicate(kp, .lessThan, value)
}

public func <= <C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> ComparisonTypedPredicate<R> {
    ComparisonTypedPredicate(kp, .lessThanOrEqualTo, value)
}

public func >= <C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> ComparisonTypedPredicate<R> {
    ComparisonTypedPredicate(kp, .greaterThanOrEqualTo, value)
}

// MARK: - optional

public func > <C: Comparable, R, K: KeyPath<R, C?>>(kp: K, value: C) -> ComparisonTypedPredicate<R> {
    ComparisonTypedPredicate(kp, .greaterThan, value)
}

public func < <C: Comparable, R, K: KeyPath<R, C?>>(kp: K, value: C) -> ComparisonTypedPredicate<R> {
    ComparisonTypedPredicate(kp, .lessThan, value)
}

public func <= <C: Comparable, R, K: KeyPath<R, C?>>(kp: K, value: C) -> ComparisonTypedPredicate<R> {
    ComparisonTypedPredicate(kp, .lessThanOrEqualTo, value)
}

public func >= <C: Comparable, R, K: KeyPath<R, C?>>(kp: K, value: C) -> ComparisonTypedPredicate<R> {
    ComparisonTypedPredicate(kp, .greaterThanOrEqualTo, value)
}
