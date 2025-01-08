//
//  ReadableBody.swift
//
//
//  Created by Andrew Barba on 12/5/22.
//

public protocol ReadableBody: Actor, Sendable {

    var used: Bool { get async }

    var body: Fastly.Body { get }

    func close() async throws

    func pipeTo(_ dest: WritableBody, preventClose: Bool) async throws

    func decode<T>(_ type: T.Type, decoder: JSONDecoder) async throws -> T where T: Decodable

    func json<T: Sendable>() async throws -> T

    func jsonObject() async throws -> [String: Sendable]

    func jsonArray() async throws -> [Sendable]

    func formValues() async throws -> HTTPSearchParams

    func text() async throws -> String

    func data() async throws -> Data

    func bytes() async throws -> [UInt8]
}

extension ReadableBody {

    public func decode<T>(decoder: JSONDecoder) async throws -> T where T: Decodable {
        return try await decode(T.self, decoder: decoder)
    }

    public func pipeTo(_ dest: WritableBody) async throws {
        try await pipeTo(dest, preventClose: false)
    }
}
