//
//  ReadableBody.swift
//  
//
//  Created by Andrew Barba on 1/16/22.
//

import Foundation

public actor ReadableBody {

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

extension ReadableBody {

    public func pipeTo(_ dest: WritableBody, preventClose: Bool = false) async throws {
        var destBody = await dest.body
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

    public func json() throws -> Any {
        let data = try data()
        return try JSONSerialization.jsonObject(with: data, options: [])
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
        var bytes: [UInt8] = []
        try body.read { chunk in
            bytes.append(contentsOf: chunk)
            return .continue
        }
        return bytes
    }
}
