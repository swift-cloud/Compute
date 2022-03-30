//
//  ObjectStore.swift
//  
//
//  Created by Andrew Barba on 3/30/22.
//

import ComputeRuntime
import Foundation

public struct ObjectStore: Sendable {

    internal let handle: StoreHandle

    public let name: String

    internal init(name: String) throws {
        var handle: StoreHandle = 0
        try wasi(fastly_kv__open(name, name.utf8.count, &handle))
        self.handle = handle
        self.name = name
    }

    public func lookup(_ key: String) throws -> ReadableBody {
        var bodyHandle: BodyHandle = 0
        try wasi(fastly_kv__lookup(handle, key, key.utf8.count, &bodyHandle))
        let body = HttpBody(bodyHandle)
        return ReadableBody(body)
    }

    public func has(_ key: String) -> Bool {
        do {
            _ = try lookup(key)
            return true
        } catch {
            return false
        }
    }

    public func insert(_ key: String, body: HttpBody, maxAge: Int = 0) throws {
        var inserted: UInt32 = 0
        try wasi(fastly_kv__insert(handle, key, key.utf8.count, body.handle, .init(maxAge), &inserted))
    }

    public func insert(_ key: String, bytes: [UInt8], maxAge: Int = 0) throws {
        var body = try HttpBody()
        try body.write(bytes)
        return try insert(key, body: body, maxAge: maxAge)
    }

    public func insert(_ key: String, data: Data, maxAge: Int = 0) throws {
        return try insert(key, bytes: .init(data), maxAge: maxAge)
    }

    public func insert(_ key: String, text: String, maxAge: Int = 0) throws {
        let data = text.data(using: .utf8) ?? .init()
        return try insert(key, data: data, maxAge: maxAge)
    }

    public func insert(_ key: String, jsonObject: [String: Any], maxAge: Int = 0) throws {
        let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
        return try insert(key, data: data, maxAge: maxAge)
    }

    public func insert(_ key: String, jsonArray: [Any], maxAge: Int = 0) throws {
        let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
        return try insert(key, data: data, maxAge: maxAge)
    }

    public func insert<T>(_ key: String, value: T, encoder: JSONEncoder = .init(), maxAge: Int = 0) throws where T: Encodable {
        let data = try encoder.encode(value)
        return try insert(key, data: data, maxAge: maxAge)
    }
}
