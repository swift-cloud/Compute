//
//  Store.swift
//
//
//  Created by Andrew Barba on 3/30/22.
//

import ComputeRuntime

extension Fastly {
    public struct KVStore: Sendable {

        internal let handle: WasiHandle

        public let name: String

        public init(name: String) throws {
            var handle: WasiHandle = 0
            try wasi(fastly_object_store__open(name, name.utf8.count, &handle))
            self.handle = handle
            self.name = name
        }

        public func lookup(_ key: String) async throws -> Body? {
            do {
                var bodyHandle: WasiHandle = InvalidWasiHandle
                try wasi(fastly_object_store__lookup(handle, key, key.utf8.count, &bodyHandle))
                return bodyHandle == InvalidWasiHandle ? nil : Body(bodyHandle)
            } catch WasiStatus.none {
                return nil
            }
        }

        public func insert(_ key: String, body: Body) async throws {
            try wasi(fastly_object_store__insert(handle, key, key.utf8.count, body.handle))
        }

        public func insert(_ key: String, bytes: [UInt8]) async throws {
            var body = try Body()
            try body.write(bytes)
            try await insert(key, body: body)
        }
    }
}
