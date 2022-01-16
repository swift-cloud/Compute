//
//  WritableBody.swift
//
//
//  Created by Andrew Barba on 1/16/22.
//

import Foundation

public enum WritableBodyError: Error {
    case invalidLockedWrite
}

public actor WritableBody {

    internal private(set) var body: HttpBody

    public private(set) var locked: Bool = false

    internal init(_ body: HttpBody) {
        self.body = body
    }

    internal init(_ bodyHandle: BodyHandle) {
        self.body = .init(bodyHandle)
    }

    public func close() throws {
        try body.close()
    }

    private func lock() -> Bool {
        guard locked == false else {
            return false
        }
        locked = true
        return true
    }

    private func unlock() {
        locked = false
    }
}

extension WritableBody {

    public func append(_ source: ReadableBody) async throws {
        try await body.append(source.body)
    }

    public func pipeFrom(_ source: ReadableBody, preventClose: Bool = false) async throws {
        try await source.pipeTo(self, preventClose: preventClose)
    }

    public func write<T>(_ object: T, encoder: JSONEncoder = .init()) throws where T: Encodable {
        let data = try encoder.encode(object)
        try write(data)
    }

    public func write(_ jsonObject: [String: Any]) throws {
        let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
        try write(data)
    }

    public func write(_ jsonArray: [Any]) throws {
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
        guard lock() == true else {
            throw WritableBodyError.invalidLockedWrite
        }
        try body.write(bytes)
        unlock()
    }
}
