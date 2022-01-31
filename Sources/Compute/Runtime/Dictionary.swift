//
//  Dictionary.swift
//  
//
//  Created by Andrew Barba on 1/12/22.
//

import ComputeRuntime

public struct Dictionary: Sendable {
    
    internal let handle: DictionaryHandle
    
    public init(name: String) throws {
        var handle: DictionaryHandle = 0
        try wasi(fastly_dictionary__open(name, name.utf8.count, &handle))
        self.handle = handle
    }

    public func get(_ key: String) -> String? {
        return try? wasiString(maxBufferLength: maxDictionaryEntryLength) {
            fastly_dictionary__get(handle, key, key.utf8.count, $0, $1, &$2)
        }
    }

    public subscript(key: String) -> String? {
        return self.get(key)
    }

    public subscript(key: String, default value: String) -> String {
        return self.get(key) ?? value
    }
}
