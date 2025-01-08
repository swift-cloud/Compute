//
//  KVStore.swift
//
//
//  Created by Andrew Barba on 3/31/22.
//

public struct KVStore: Sendable {

    internal let store: Fastly.KVStore

    public init(name: String) throws {
        store = try .init(name: name)
    }

    public var name: String {
        store.name
    }
}

// MARK: - Entry

extension KVStore {

    public struct Entry: Sendable {

        public let body: ReadableBody
    }
}

// MARK: - Read

extension KVStore {

    public func get(_ key: String) async throws -> Entry? {
        guard let body = try await store.lookup(key) else {
            return nil
        }
        return .init(body: ReadableWasiBody(body))
    }

    public func has(_ key: String) async throws -> Bool {
        switch try await store.lookup(key) {
        case .some:
            return true
        case .none:
            return false
        }
    }
}

// MARK: - Update

extension KVStore {

    public func put(_ key: String, body: ReadableBody) async throws {
        try await store.insert(key, body: body.body)
    }

    public func put(_ key: String, bytes: [UInt8]) async throws {
        try await store.insert(key, bytes: bytes)
    }

    public func put(_ key: String, data: Data) async throws {
        try await put(key, bytes: .init(data))
    }

    public func put(_ key: String, text: String) async throws {
        let data = text.data(using: .utf8) ?? .init()
        try await put(key, data: data)
    }

    public func put(_ key: String, jsonObject: [String: Any]) async throws {
        let data = try JSONSerialization.data(withJSONObject: jsonObject)
        try await put(key, data: data)
    }

    public func put(_ key: String, jsonArray: [Any]) async throws {
        let data = try JSONSerialization.data(withJSONObject: jsonArray)
        try await put(key, data: data)
    }

    public func put<T>(_ key: String, value: T, encoder: JSONEncoder = .init()) async throws
    where T: Encodable {
        let data = try encoder.encode(value)
        try await put(key, data: data)
    }
}
