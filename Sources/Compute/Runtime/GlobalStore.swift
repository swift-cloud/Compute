//
//  GlobalStore.swift
//  
//
//  Created by Andrew Barba on 3/30/22.
//

import ComputeRuntime

public struct GlobalStore: Sendable {

    internal let handle: StoreHandle

    public let name: String

    public init(name: String) throws {
        var handle: StoreHandle = 0
        try wasi(fastly_kv__open(name, name.utf8.count, &handle))
        self.handle = handle
        self.name = name
    }

    public func lookup(_ key: String) throws -> HttpBody {
        var bodyHandle: BodyHandle = 0
        try wasi(fastly_kv__lookup(handle, key, key.utf8.count, &bodyHandle))
        return HttpBody(bodyHandle)
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
}
