//
//  WritableBody.swift
//
//
//  Created by Andrew Barba on 1/16/22.
//

import Foundation

public actor WritableBody: Sendable {

    public var used: Bool {
        return body.used
    }

    internal private(set) var body: HttpBody

    internal init(_ body: HttpBody) {
        self.body = body
    }

    internal init(_ bodyHandle: BodyHandle) {
        self.body = .init(bodyHandle)
    }

    public func close() throws {
        try body.close()
    }
}

extension WritableBody {

    public func append(_ source: isolated ReadableBody) throws {
        try body.append(source.body)
    }

    public func pipeFrom(_ source: isolated ReadableBody, preventClose: Bool = false) throws {
        try source.pipeTo(self, preventClose: preventClose)
    }
}

extension WritableBody {

    public func write<T>(_ value: T, encoder: JSONEncoder = .init()) throws where T: Encodable {
        let data = try encoder.encode(value)
        try write(data)
    }

    public func write(_ jsonObject: [String: Sendable]) throws {
        let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
        try write(data)
    }

    public func write(_ jsonArray: [Sendable]) throws {
        let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
        try write(data)
    }

    public func write(_ text: String) throws {
        let data = text.data(using: .utf8) ?? .init()
        try write(data)
    }

    public func write(_ data: Data) throws {
        let bytes: [UInt8] = .init(data)
        try write(bytes)
    }

    public func write(_ bytes: [UInt8]) throws {
        try body.write(bytes)
    }
}
