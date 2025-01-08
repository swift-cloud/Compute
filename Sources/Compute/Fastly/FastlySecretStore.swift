//
//  FastlySecretStore.swift
//
//
//  Created by Andrew Barba on 12/2/22.
//

import ComputeRuntime

extension Fastly {
    public struct SecretStore: Sendable {

        internal let handle: WasiHandle

        public let name: String

        public init(name: String) throws {
            var handle: WasiHandle = InvalidWasiHandle
            try wasi(fastly_secret_store__open(name, name.utf8.count, &handle))
            self.handle = handle
            self.name = name
        }

        public func get(_ key: String) -> String? {
            var secretHandle: WasiHandle = InvalidWasiHandle
            try? wasi(fastly_secret_store__lookup(handle, key, key.utf8.count, &secretHandle))
            guard secretHandle != InvalidWasiHandle else {
                return nil
            }
            return try? wasiString(maxBufferLength: maxDictionaryEntryLength) {
                fastly_secret_store__plaintext(secretHandle, $0, $1, &$2)
            }
        }

        public subscript(key: String) -> String? {
            return self.get(key)
        }

        public subscript(key: String, default value: String) -> String {
            return self.get(key) ?? value
        }
    }
}
