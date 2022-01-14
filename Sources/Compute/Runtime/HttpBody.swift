//
//  HttpBody.swift
//  
//
//  Created by Andrew Barba on 1/13/22.
//

import ComputeRuntime
import Foundation

public struct HttpBody {

    internal let handle: BodyHandle

    internal init(_ handle: BodyHandle) {
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

    @discardableResult
    public func write<T>(_ object: T, encoder: JSONEncoder = .init(), location: BodyWriteEnd = .back) throws -> Int where T: Encodable {
        let data = try encoder.encode(object)
        return try write(data)
    }

    @discardableResult
    public func write(_ text: String, location: BodyWriteEnd = .back) throws -> Int {
        return try write(text.data(using: .utf8) ?? .init())
    }

    @discardableResult
    public func write(_ data: Data, location: BodyWriteEnd = .back) throws -> Int {
        return try write(Array<UInt8>(data))
    }

    @discardableResult
    public func write(_ bytes: [UInt8], location: BodyWriteEnd = .back) throws -> Int {
        var position = 0
        while position < bytes.count {
            try bytes[position..<bytes.count].withUnsafeBufferPointer {
                var written: Int32 = 0
                try wasi(fastly_http_body__write(handle, $0.baseAddress, .init($0.count), location.rawValue, &written))
                position += .init(written)
            }
        }
        return position
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
