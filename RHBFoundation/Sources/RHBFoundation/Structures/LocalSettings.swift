import Foundation

public final class LocalSettings {
    let userDefaults: UserDefaults

    public init(_ userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}

// MARK: - codable

public extension LocalSettings {
    func save<T: Encodable>(object: T?, key: String = #function) {
        let data = object.flatMap {
            try? JSONEncoder().encode($0)
        }
        userDefaults.set(data, forKey: key)
    }

    func load<T: Decodable>(key: String = #function) -> T? {
        userDefaults.data(forKey: key).flatMap {
            try? JSONDecoder().decode(T.self, from: $0)
        }
    }
}
