//
//  WritableBody.swift
//
//
//  Created by Andrew Barba on 1/16/22.
//

public actor WritableBody: Sendable {

    public var used: Bool {
        return body.used
    }

    internal private(set) var body: Fastly.Body

    internal let writable: Bool

    internal init(_ body: Fastly.Body, writable: Bool = true) {
        self.body = body
        self.writable = writable
    }

    internal init(_ bodyHandle: WasiHandle, writable: Bool = true) {
        self.body = .init(bodyHandle)
        self.writable = writable
    }

    public func close() async throws {
        try body.close()
        try await Task.nextTick()
    }
}

extension WritableBody {

    public func append(_ source: ReadableBody) async throws {
        guard writable else { return }
        try await body.append(source.body)
        try await Task.nextTick()
    }

    public func pipeFrom(_ source: ReadableBody, preventClose: Bool = false) async throws {
        guard writable else { return }
        try await source.pipeTo(self, preventClose: preventClose)
    }
}

extension WritableBody {

    public func write<T>(
        _ value: T,
        encoder: JSONEncoder = .init(),
        formatting: JSONEncoder.OutputFormatting = [.sortedKeys]
    ) async throws where T: Encodable {
        encoder.outputFormatting = formatting
        let data = try encoder.encode(value)
        try await write(data)
    }

    public func write(
        _ jsonObject: [String: Sendable],
        options: JSONSerialization.WritingOptions = [.sortedKeys]
    ) async throws {
        let data = try JSONSerialization.data(withJSONObject: jsonObject, options: options)
        try await write(data)
    }

    public func write(
        _ jsonArray: [Sendable],
        options: JSONSerialization.WritingOptions = [.sortedKeys]
    ) async throws {
        let data = try JSONSerialization.data(withJSONObject: jsonArray, options: options)
        try await write(data)
    }

    public func write(_ text: String) async throws {
        let data = text.data(using: .utf8) ?? .init()
        try await write(data)
    }

    public func write(_ data: Data) async throws {
        let bytes: [UInt8] = .init(data)
        try await write(bytes)
    }

    public func write(_ bytes: [UInt8]) async throws {
        guard writable else { return }
        try body.write(bytes)
        try await Task.nextTick()
    }
}
