import Foundation

public enum StringComparatorType {
    case compare
    case caseInsensitiveCompare
    case localizedCompare
    case localizedCaseInsensitiveCompare
    case localizedStandardCompare
}

// MARK: - internal

extension StringComparatorType: CaseIterable {
    var selector: Selector {
        switch self {
            case .compare:
                return #selector(NSString.compare(_:))
            case .caseInsensitiveCompare:
                return #selector(NSString.caseInsensitiveCompare)
            case .localizedCompare:
                return #selector(NSString.localizedCompare)
            case .localizedCaseInsensitiveCompare:
                return #selector(NSString.localizedCaseInsensitiveCompare)
            case .localizedStandardCompare:
                return #selector(NSString.localizedStandardCompare)
        }
    }
}
