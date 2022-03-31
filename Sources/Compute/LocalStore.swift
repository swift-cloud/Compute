//
//  LocalStore.swift
//  
//
//  Created by Andrew Barba on 3/30/22.
//

import Foundation

public struct LocalStore: Sendable {

    internal let store: Store

    public init() throws {
        store = try .init(name: localStoreName)
    }

    public func lookup(_ key: String) throws -> ReadableBody? {
        guard let body = try store.lookup(key) else {
            return nil
        }
        return .init(body)
    }

    public func has(_ key: String) throws -> Bool {
        switch try lookup(key) {
        case .some:
            return true
        case .none:
            return false
        }
    }

    public func insert(_ key: String, body: ReadableBody, maxAge: Int = 0) async throws {
        try await store.insert(key, body: body.body, maxAge: maxAge)
    }

    public func insert(_ key: String, bytes: [UInt8], maxAge: Int = 0) throws {
        try store.insert(key, bytes: bytes, maxAge: maxAge)
    }

    public func insert(_ key: String, data: Data, maxAge: Int = 0) throws {
        try insert(key, bytes: .init(data), maxAge: maxAge)
    }

    public func insert(_ key: String, text: String, maxAge: Int = 0) throws {
        let data = text.data(using: .utf8) ?? .init()
        try insert(key, data: data, maxAge: maxAge)
    }

    public func insert(_ key: String, jsonObject: [String: Any], maxAge: Int = 0) throws {
        let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
        try insert(key, data: data, maxAge: maxAge)
    }

    public func insert(_ key: String, jsonArray: [Any], maxAge: Int = 0) throws {
        let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
        try insert(key, data: data, maxAge: maxAge)
    }

    public func insert<T>(_ key: String, value: T, encoder: JSONEncoder = .init(), maxAge: Int = 0) throws where T: Encodable {
        let data = try encoder.encode(value)
        try insert(key, data: data, maxAge: maxAge)
    }
}
