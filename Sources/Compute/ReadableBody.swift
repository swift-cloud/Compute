//
//  ReadableBody.swift
//  
//
//  Created by Andrew Barba on 1/16/22.
//

import Foundation

public actor ReadableBody: Sendable {

    public var used: Bool {
        return body.used
    }

    internal private(set) var body: Body

    private var _bytes: [UInt8]? = nil

    internal init(_ body: Body) {
        self.body = body
    }

    internal init(_ bodyHandle: BodyHandle) {
        self.body = .init(bodyHandle)
    }

    public func close() throws {
        try body.close()
    }
}

extension ReadableBody {

    public func pipeTo(_ dest: isolated WritableBody, preventClose: Bool = false) throws {
        var destBody = dest.body
        try body.read {
            try destBody.write($0)
            return .continue
        }
        if preventClose == false {
            try destBody.close()
        }
    }
}

extension ReadableBody {

    public func decode<T>(_ type: T.Type, decoder: JSONDecoder = .init()) throws -> T where T: Decodable {
        let data = try data()
        return try decoder.decode(type, from: data)
    }

    public func json() throws -> Sendable {
        let data = try data()
        let dict = try JSONSerialization.jsonObject(with: data, options: [])
        return dict as! Sendable
    }

    public func jsonObject() throws -> [String: Sendable] {
        return try json() as! [String: Sendable]
    }

    public func jsonArray() throws -> [Sendable] {
        return try json() as! [Sendable]
    }

    public func formValues() throws -> [String: String] {
        let query = try text()
        let components = URLComponents(string: "?\(query)")
        let queryItems = components?.queryItems ?? []
        return queryItems.reduce(into: [:]) { values, item in
            values[item.name] = item.value
        }
    }

    public func text() throws -> String {
        let data = try data()
        return String(data: data, encoding: .utf8) ?? ""
    }

    public func data() throws -> Data {
        let bytes = try bytes()
        return Data(bytes)
    }

    public func bytes() throws -> [UInt8] {
        // Check if we've already ready the bytes from this stream
        if let _bytes = _bytes {
            return _bytes
        }

        // Create new bytes array
        var bytes: [UInt8] = []

        // Scan all bytes into new bytes array
        try body.read { chunk in
            bytes.append(contentsOf: chunk)
            return .continue
        }

        // Save bytes for future reads
        _bytes = bytes

        // Return new bytes array
        return bytes
    }
}
