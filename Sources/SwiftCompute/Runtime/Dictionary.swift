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
            let pointer = UnsafeMutablePointer(mutating: $0)
            try wasi(fastly_dictionary__open(pointer, Int32(name.utf8.count), &handle))
        }
        self.handle = handle
    }

    public func get(key: String) throws -> String {
        var resultMaxLength: Int32 = 128
        var resultLength: Int32 = 0
        var resultPointer = UnsafeMutablePointer<CChar>.allocate(capacity: Int(resultMaxLength))
        try key.withCString {
            let pointer = UnsafeMutablePointer(mutating: $0)
            let pointerLength = Int32(key.utf8.count)
            while true {
                do {
                    try wasi(fastly_dictionary__get(handle, pointer, pointerLength, resultPointer, resultMaxLength, &resultLength))
                    break
                } catch WasiStatus.bufferTooSmall {
                    resultMaxLength *= 2
                    resultPointer = .allocate(capacity: Int(resultMaxLength))
                } catch {
                    throw error
                }
            }
        }
        return String(cString: resultPointer)
    }
}
