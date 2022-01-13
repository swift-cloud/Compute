//
//  File.swift
//  
//
//  Created by Andrew Barba on 1/12/22.
//

import ComputeRuntime

public struct Logger {
    private let handle: EndpointHandle

    public init(name: String) throws {
        var handle: DictionaryHandle = 0
        try name.withCString {
            let pointer = UnsafeMutablePointer(mutating: $0)
            try wasi(fastly_log__endpoint_get(pointer, Int32(name.utf8.count), &handle))
        }
        self.handle = handle
    }

    @discardableResult
    public func write(_ messages: String...) throws -> Int {
        let message = messages.joined(separator: " ")
        var result: Int32 = 0
        try message.withCString {
            let pointer = UnsafeMutablePointer(mutating: $0)
            try wasi(fastly_log__write(handle, pointer, Int32(message.utf8.count), &result))
        }
        return Int(result)
    }
}
