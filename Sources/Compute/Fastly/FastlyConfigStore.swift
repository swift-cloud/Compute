//
//  ConfigStore.swift
//  
//
//  Created by Andrew Barba on 1/12/22.
//

import FastlyWorld

extension Fastly {
    public struct ConfigStore: Sendable {

        internal let handle: fastly_dictionary_handle_t

        public let name: String

        public init(name: String) throws {
            var name_t = name.fastly_world_t
            var handle: fastly_dictionary_handle_t = 0
            try fastlyWorld { err in
                fastly_dictionary_open(&name_t, &handle, &err)
            }
            self.handle = handle
            self.name = name
        }

        public func get(_ key: String) throws -> String? {
            var key_t = key.fastly_world_t
            var val_t = fastly_option_string_t()
            try fastlyWorld { err in
                fastly_dictionary_get(handle, &key_t, &val_t, &err)
            }
            return val_t.value
        }
    }
}
