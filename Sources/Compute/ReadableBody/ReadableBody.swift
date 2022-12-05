//
//  ReadableBody.swift
//  
//
//  Created by Andrew Barba on 12/5/22.
//

public protocol ReadableBody: Actor, Sendable {

    var used: Bool { get }

    var body: Fastly.Body { get }

    func close() async throws

    func pipeTo(_ dest: isolated WritableBody, preventClose: Bool) async throws

    func decode<T>(decoder: JSONDecoder) async throws -> T where T: Decodable

    func json() async throws -> Sendable

    func jsonObject() async throws -> [String: Sendable]

    func jsonArray() async throws -> [Sendable]

    func formValues() async throws -> [String: String]

    func text() async throws -> String

    func data() async throws -> Data

    func bytes() async throws -> [UInt8]
}

extension ReadableBody {

    public func pipeTo(_ dest: isolated WritableBody) async throws {
        try await pipeTo(dest, preventClose: false)
    }
}
