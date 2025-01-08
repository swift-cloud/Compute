//
//  ConfigStore.swift
//
//
//  Created by Andrew Barba on 11/27/22.
//

public struct ConfigStore: Sendable {

    internal let store: Fastly.ConfigStore

    public let name: String

    public init(name: String) throws {
        self.store = try .init(name: name)
        self.name = name
    }

    public func get(_ key: String) -> String? {
        return try? store.get(key)
    }

    public subscript(key: String) -> String? {
        return self.get(key)
    }

    public subscript(key: String, default value: String) -> String {
        return self.get(key) ?? value
    }
}
