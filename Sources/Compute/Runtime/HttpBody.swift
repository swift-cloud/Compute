//
//  HttpBody.swift
//  
//
//  Created by Andrew Barba on 1/13/22.
//

import ComputeRuntime
import Foundation

public struct HttpBody {

    private let handle: BodyHandle

    public init(_ handle: BodyHandle) {
        self.handle = handle
    }

    public init() throws {
        var handle: BodyHandle = 0
        try wasi(fastly_http_body__new(&handle))
        self.handle = handle
    }

    public func append(_ source: HttpBody) throws {
        try wasi(fastly_http_body__append(handle, source.handle))
    }

    public func close() throws {
        try wasi(fastly_http_body__close(handle))
    }

    public func write(_ data: Data, location: BodyWriteEnd = .back) throws -> Int {
        return try write(Array<UInt8>(data))
    }

    public func write(_ data: [UInt8], location: BodyWriteEnd = .back) throws -> Int {
        var result: Int32 = 0
        try wasi(fastly_http_body__write(handle, data, .init(data.count), location.rawValue, &result))
        return .init(result)
    }

    public func read(size: Int) throws -> Data {
        let bytes: [UInt8] = try read(size: size)
        return Data(bytes)
    }

    public func read(size: Int) throws -> [UInt8] {
        return try Array<UInt8>(unsafeUninitializedCapacity: size) {
            var length: Int32 = 0
            try wasi(fastly_http_body__read(handle, $0.baseAddress, .init(size), &length))
            $1 = .init(length)
        }
    }
}
