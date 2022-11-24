//
//  Store.swift
//  
//
//  Created by Andrew Barba on 3/30/22.
//

import ComputeRuntime

internal struct FastlyObjectStore: Sendable {

    let handle: WasiHandle

    let name: String

    init(name: String) throws {
        var handle: WasiHandle = 0
        try wasi(fastly_object_store__open(name, name.utf8.count, &handle))
        self.handle = handle
        self.name = name
    }

    func lookup(_ key: String) throws -> Body? {
        do {
            var bodyHandle: WasiHandle = InvalidWasiHandle
            try wasi(fastly_object_store__lookup(handle, key, key.utf8.count, &bodyHandle))
            return bodyHandle == InvalidWasiHandle ? nil : Body(bodyHandle)
        } catch WasiStatus.none {
            return nil
        }
    }

    func insert(_ key: String, body: Body) throws {
        try wasi(fastly_object_store__insert(handle, key, key.utf8.count, body.handle))
    }

    func insert(_ key: String, bytes: [UInt8]) throws {
        var body = try Body()
        try body.write(bytes)
        try insert(key, body: body)
    }
}
