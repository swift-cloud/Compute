//
//  Dictionary.swift
//  
//
//  Created by Andrew Barba on 1/12/22.
//

import ComputeRuntime

public struct FastlyDictionary {
    
    private let handle: DictionaryHandle
    
    public init(name: String) throws {
        var handle: DictionaryHandle = 0
        try wasi(fastly_dictionary__open(name, .init(name.utf8.count), &handle))
        self.handle = handle
    }

    public func get(key: String) throws -> String? {
        var length: Int32 = 0
        do {
            try wasi(fastly_dictionary__get(handle, key, .init(key.utf8.count), nil, maxBufferLength, &length))
        } catch {
            return nil
        }
        let bytes = try Array<UInt8>(unsafeUninitializedCapacity: .init(length)) {
            try wasi(fastly_dictionary__get(handle, key, .init(key.utf8.count), $0.baseAddress, length, nil))
            $1 = .init(length)
        }
        return String(bytes: bytes, encoding: .utf8)
    }
}
