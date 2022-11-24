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

    internal private(set) var body: Body

    internal let writable: Bool

    internal init(_ body: Body, writable: Bool = true) {
        self.body = body
        self.writable = writable
    }

    internal init(_ bodyHandle: WasiHandle, writable: Bool = true) {
        self.body = .init(bodyHandle)
        self.writable = writable
    }

    public func close() throws {
        try body.close()
    }
}

extension WritableBody {

    public func append(_ source: isolated ReadableBody) throws {
        guard writable else { return }
        try body.append(source.body)
    }

    public func pipeFrom(_ source: isolated ReadableBody, preventClose: Bool = false) throws {
        guard writable else { return }
        try source.pipeTo(self, preventClose: preventClose)
    }
}

extension WritableBody {

    public func write<T>(
        _ value: T,
        encoder: JSONEncoder = .init(),
        formatting: JSONEncoder.OutputFormatting = [.sortedKeys]
    ) throws where T: Encodable {
        encoder.outputFormatting = formatting
        let data = try encoder.encode(value)
        try write(data)
    }

    public func write(
        _ jsonObject: [String: Sendable],
        options: JSONSerialization.WritingOptions = [.sortedKeys]
    ) throws {
        let data = try JSONSerialization.data(withJSONObject: jsonObject, options: options)
        try write(data)
    }

    public func write(
        _ jsonArray: [Sendable],
        options: JSONSerialization.WritingOptions = [.sortedKeys]
    ) throws {
        let data = try JSONSerialization.data(withJSONObject: jsonArray, options: options)
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
        guard writable else { return }
        try body.write(bytes)
    }
}
