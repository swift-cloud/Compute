//
//  FastlySecretStore.swift
//  
//
//  Created by Andrew Barba on 12/2/22.
//

import FastlyWorld

extension Fastly {
    public struct SecretStore: Sendable {

        internal let handle: WasiHandle

        public let name: String

        public init(name: String) throws {
            var handle: WasiHandle = InvalidWasiHandle
            var name_t = name.fastly_world_t
            try fastlyWorld { err in
                fastly_secret_store_open(&name_t, &handle, &err)
            }
            self.handle = handle
            self.name = name
        }

        public func get(_ key: String) throws -> String? {
            var secret_t = fastly_world_option_secret_handle_t()
            var key_t = key.fastly_world_t
            var value_t = fastly_world_option_string_t()
            try fastlyWorld { err in
                fastly_secret_store_get(handle, &key_t, &secret_t, &err)
            }
            guard secret_t.is_some else {
                return nil
            }
            try fastlyWorld { err in
                fastly_secret_store_plaintext(secret_t.val, &value_t, &err)
            }
            guard value_t.is_some else {
                return nil
            }
            return value_t.value
        }

        public subscript(key: String) -> String? {
            return try? self.get(key)
        }

        public subscript(key: String, default value: String) -> String {
            return (try? self.get(key)) ?? value
        }
    }
}
