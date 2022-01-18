//
//  HttpBody.swift
//  
//
//  Created by Andrew Barba on 1/13/22.
//

import ComputeRuntime
import Foundation

public struct HttpBody {

    public private(set) var used: Bool = false

    internal let handle: BodyHandle

    internal init(_ handle: BodyHandle) {
        self.handle = handle
    }

    internal init() throws {
        var handle: BodyHandle = 0
        try wasi(fastly_http_body__new(&handle))
        self.handle = handle
    }

    public mutating func append(_ source: HttpBody) throws {
        try wasi(fastly_http_body__append(handle, source.handle))
        used = true
    }

    public mutating func close() throws {
        try wasi(fastly_http_body__close(handle))
    }

    @discardableResult
    public mutating func write(_ bytes: [UInt8], location: BodyWriteEnd = .back) throws -> Int {
        defer { used = true }
        var position = 0
        while position < bytes.count {
            try bytes[position..<bytes.count].withUnsafeBufferPointer {
                var written = 0
                try wasi(fastly_http_body__write(handle, $0.baseAddress, $0.count, location.rawValue, &written))
                position += written
            }
        }
        return position
    }

    public mutating func next(highWaterMark: Int = highWaterMark) throws -> [UInt8] {
        defer { used = true }
        return try Array<UInt8>(unsafeUninitializedCapacity: highWaterMark) {
            var length = 0
            try wasi(fastly_http_body__read(handle, $0.baseAddress, highWaterMark, &length))
            $1 = length
        }
    }

    public mutating func read(highWaterMark: Int = highWaterMark, onChunk: ([UInt8]) throws -> BodyScanContinuation) throws {
        while true {
            // Read chunk based on appropriate offset
            let chunk = try next(highWaterMark: highWaterMark)

            // Make sure we read new bytes, else break
            guard chunk.count > 0 else {
                return
            }

            // Trigger callback
            guard try onChunk(chunk) == .continue else {
                return
            }
        }
    }
}
