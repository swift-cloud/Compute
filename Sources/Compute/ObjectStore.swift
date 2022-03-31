//
//  ObjectStore.swift
//  
//
//  Created by Andrew Barba on 3/31/22.
//

import Foundation

public struct ObjectStore: Sendable {

    internal let store: Store

    public init(name: String) throws {
        store = try .init(name: name)
    }

    public var name: String {
        store.name
    }

    public func lookup(_ key: String) async throws -> ReadableBody? {
        guard let body = try store.lookup(key) else {
            return nil
        }
        return .init(body)
    }

    public func has(_ key: String) async throws -> Bool {
        switch try await lookup(key) {
        case .some:
            return true
        case .none:
            return false
        }
    }

    public func insert(_ key: String, body: ReadableBody, maxAge: Int = 0) async throws {
        try await store.insert(key, body: body.body, maxAge: maxAge)
    }

    public func insert(_ key: String, bytes: [UInt8], maxAge: Int = 0) async throws {
        try store.insert(key, bytes: bytes, maxAge: maxAge)
    }

    public func insert(_ key: String, data: Data, maxAge: Int = 0) async throws {
        try await insert(key, bytes: .init(data), maxAge: maxAge)
    }

    public func insert(_ key: String, text: String, maxAge: Int = 0) async throws {
        let data = text.data(using: .utf8) ?? .init()
        try await insert(key, data: data, maxAge: maxAge)
    }

    public func insert(_ key: String, jsonObject: [String: Any], maxAge: Int = 0) async throws {
        let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
        try await insert(key, data: data, maxAge: maxAge)
    }

    public func insert(_ key: String, jsonArray: [Any], maxAge: Int = 0) async throws {
        let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
        try await insert(key, data: data, maxAge: maxAge)
    }

    public func insert<T>(_ key: String, value: T, encoder: JSONEncoder = .init(), maxAge: Int = 0) async throws where T: Encodable {
        let data = try encoder.encode(value)
        try await insert(key, data: data, maxAge: maxAge)
    }
}

