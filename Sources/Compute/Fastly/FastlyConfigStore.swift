//
//  Dictionary.swift
//
//
//  Created by Andrew Barba on 1/12/22.
//

import ComputeRuntime

extension Fastly {
    public struct ConfigStore: Sendable {

        internal let handle: WasiHandle

        public let name: String

        public init(name: String) throws {
            var handle: WasiHandle = 0
            try wasi(fastly_dictionary__open(name, name.utf8.count, &handle))
            self.handle = handle
            self.name = name
        }

        public func get(_ key: String) throws -> String? {
            return try wasiString(maxBufferLength: maxDictionaryEntryLength) {
                fastly_dictionary__get(handle, key, key.utf8.count, $0, $1, &$2)
            }
        }
    }
}
