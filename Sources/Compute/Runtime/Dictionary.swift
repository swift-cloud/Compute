//
//  Dictionary.swift
//  
//
//  Created by Andrew Barba on 1/12/22.
//

import ComputeRuntime

public struct Dictionary {
    
    internal let handle: DictionaryHandle
    
    public init(name: String) throws {
        var handle: DictionaryHandle = 0
        try wasi(fastly_dictionary__open(name, .init(name.utf8.count), &handle))
        self.handle = handle
    }

    public func get(key: String) throws -> String? {
        return try wasiString(maxBufferLength: maxDictionaryEntryLength) {
            fastly_dictionary__get(handle, key, .init(key.utf8.count), $0, $1, &$2)
        }
    }
}
