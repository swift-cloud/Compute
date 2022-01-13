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
        try name.withCString {
            try wasi(fastly_dictionary__open($0, .init(name.count), &handle))
        }
        self.handle = handle
    }

    public func get(key: String) throws -> String {
        let valueMaxLength: Int32 = 8000
        var valueLength: Int32 = 0
        return try key.withCString { keyBuffer in
            try wasi(fastly_dictionary__get(handle, keyBuffer, .init(key.count), nil, valueMaxLength, &valueLength))
            let valueBytes = try Array<CChar>(unsafeUninitializedCapacity: .init(valueLength)) { buffer, _ in
                try wasi(fastly_dictionary__get(handle, keyBuffer, .init(key.count), buffer.baseAddress, valueMaxLength, &valueLength))
            }
            return String(cString: valueBytes)
        }
    }
}
