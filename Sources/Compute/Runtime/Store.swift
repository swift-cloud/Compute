//
//  Store.swift
//  
//
//  Created by Andrew Barba on 3/30/22.
//

import ComputeRuntime

public struct Store: Sendable {

    internal let handle: StoreHandle

    public let name: String

    internal init(name: String) throws {
        var handle: StoreHandle = 0
        try wasi(fastly_kv__open(name, name.utf8.count, &handle))
        print("store handle:", handle)
        self.handle = handle
        self.name = name
    }

    public func lookup(_ key: String) throws -> Body? {
        var bodyHandle: BodyHandle = 0
        do {
            try wasi(fastly_kv__lookup(handle, key, key.utf8.count, &bodyHandle))
            print("bodyHandle[ok]:", bodyHandle)
            return Body(bodyHandle)
        } catch WasiStatus.none {
            print("bodyHandle[none]:", bodyHandle)
            return nil
        } catch {
            print("bodyHandle[error]:", bodyHandle, error)
            throw error
        }
    }

    public func insert(_ key: String, body: Body, maxAge: Int) throws {
        var inserted: UInt32 = 0
        try wasi(fastly_kv__insert(handle, key, key.utf8.count, body.handle, .init(maxAge), &inserted))
    }

    public func insert(_ key: String, bytes: [UInt8], maxAge: Int) throws {
        var body = try Body()
        try body.write(bytes)
        try insert(key, body: body, maxAge: maxAge)
    }

    public func remove(_ key: String) throws {
        // TODO: Enable remove once fastly adds the host call
        // try wasi(fastly_kv__remove(handle, key, key.utf8.count))
    }
}
