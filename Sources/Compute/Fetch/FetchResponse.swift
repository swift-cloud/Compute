//
//  FetchResponse.swift
//
//
//  Created by Andrew Barba on 12/5/22.
//

public struct FetchResponse: Sendable {

    public let body: ReadableBody

    public let headers: Headers

    public let status: Int

    public let url: URL
}

extension FetchResponse {

    public var ok: Bool {
        return status >= 200 && status <= 299
    }

    var bodyUsed: Bool {
        get async {
            await body.used
        }
    }
}

extension FetchResponse {

    public func decode<T>(decoder: JSONDecoder = .init()) async throws -> T
    where T: Decodable & Sendable {
        return try await body.decode(decoder: decoder)
    }

    public func decode<T>(_ type: T.Type, decoder: JSONDecoder = .init()) async throws -> T
    where T: Decodable & Sendable {
        return try await body.decode(type, decoder: decoder)
    }

    public func json<T: Sendable>() async throws -> T {
        return try await body.json()
    }

    public func jsonObject() async throws -> [String: Sendable] {
        return try await body.jsonObject()
    }

    public func jsonArray() async throws -> [Sendable] {
        return try await body.jsonArray()
    }

    public func formValues() async throws -> HTTPSearchParams {
        return try await body.formValues()
    }

    public func text() async throws -> String {
        return try await body.text()
    }

    public func data() async throws -> Data {
        return try await body.data()
    }

    public func bytes() async throws -> [UInt8] {
        return try await body.bytes()
    }
}
