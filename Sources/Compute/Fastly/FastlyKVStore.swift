//
//  Store.swift
//  
//
//  Created by Andrew Barba on 3/30/22.
//

import FastlyWorld

extension Fastly {
    public struct KVStore: Sendable {

        internal let handle: WasiHandle

        public let name: String

        public init(name: String) throws {
            var handle: WasiHandle = 0
            var name_t = name.fastly_world_t
            try fastlyWorld { err in
                fastly_object_store_open(&name_t, &handle, &err)
            }
            self.handle = handle
            self.name = name
        }

        public func lookup(_ key: String) async throws -> Body? {
            var bodyHandle = fastly_world_option_body_handle_t()
            var key_t = key.fastly_world_t
            try fastlyWorld { err in
                fastly_object_store_lookup(handle, &key_t, &bodyHandle, &err)
            }
            guard bodyHandle.is_some else {
                return nil
            }
            return Body(bodyHandle.val)
        }

        public func insert(_ key: String, body: Body) async throws {
            var key_t = key.fastly_world_t
            try fastlyWorld { err in
                fastly_object_store_insert(handle, &key_t, body.handle, &err)
            }
        }

        public func insert(_ key: String, bytes: [UInt8]) async throws {
            var body = try Body()
            try body.write(bytes)
            try await insert(key, body: body)
        }
    }
}
