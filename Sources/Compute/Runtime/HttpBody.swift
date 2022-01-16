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

    public mutating func append(_ source: HttpBody) throws {
        try wasi(fastly_http_body__append(handle, source.handle))
    }

    public mutating func close() throws {
        try wasi(fastly_http_body__close(handle))
    }

    @discardableResult
    public mutating func write<T>(_ object: T, encoder: JSONEncoder = .init(), location: BodyWriteEnd = .back) throws -> Int where T: Encodable {
        let data = try encoder.encode(object)
        return try write(data)
    }

    @discardableResult
    public mutating func write(_ json: Any, location: BodyWriteEnd = .back) throws -> Int {
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        return try write(data)
    }

    @discardableResult
    public mutating func write(_ text: String, location: BodyWriteEnd = .back) throws -> Int {
        return try write(text.data(using: .utf8) ?? .init())
    }

    @discardableResult
    public mutating func write(_ data: Data, location: BodyWriteEnd = .back) throws -> Int {
        return try write(Array<UInt8>(data))
    }

    @discardableResult
    public mutating func write(_ bytes: [UInt8], location: BodyWriteEnd = .back) throws -> Int {
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

    public mutating func decode<T>(_ type: T.Type, decoder: JSONDecoder = .init()) throws -> T where T: Decodable {
        let data = try data()
        return try decoder.decode(type, from: data)
    }

    public mutating func json() throws -> Any {
        let data = try data()
        return try JSONSerialization.jsonObject(with: data, options: [])
    }

    public mutating func text() throws -> String {
        let data = try data()
        return String(data: data, encoding: .utf8) ?? ""
    }

    public mutating func data() throws -> Data {
        let bytes = try bytes()
        return Data(bytes)
    }

    public mutating func bytes() throws -> [UInt8] {
        var bytes: [UInt8] = []
        try scan {
            bytes.append(contentsOf: $0)
            return .continue
        }
        return bytes
    }

    public mutating func pipeTo(_ dest: inout HttpBody, end: Bool = true) throws {
        try scan {
            try dest.write($0)
            return .continue
        }
        if end {
            try dest.close()
        }
    }

    @discardableResult
    public mutating func scan(
        highWaterMark: Int = highWaterMark,
        onChunk: ([UInt8]) throws -> BodyScanContinuation
    ) throws -> [UInt8] {
        while true {
            // Read chunk based on appropriate offset
            let chunk = try Array<UInt8>(unsafeUninitializedCapacity: highWaterMark) {
                var length = 0
                try wasi(fastly_http_body__read(handle, $0.baseAddress, highWaterMark, &length))
                $1 = length
            }

            // Make sure we read new bytes, else break
            guard chunk.count > 0 else {
                return chunk
            }

            // Trigger callback
            guard try onChunk(chunk) == .continue else {
                return chunk
            }
        }
    }
}
