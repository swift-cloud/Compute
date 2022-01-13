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
        var handle: EndpointHandle = 0
        try wasi(fastly_log__endpoint_get(name, .init(name.utf8.count), &handle))
        self.handle = handle
    }
    
    @discardableResult
    public func write(_ messages: String...) throws -> Int {
        let message = messages.joined(separator: " ")
        var result: Int32 = 0
        try wasi(fastly_log__write(handle, message, .init(message.utf8.count), &result))
        return Int(result)
    }
}
