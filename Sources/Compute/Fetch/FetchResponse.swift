//
//  FetchResponse.swift
//  
//
//  Created by Andrew Barba on 12/5/22.
//

public protocol FetchResponse: Sendable {

    associatedtype HeadersImplementation: HeadersProvider

    var body: ReadableBody { get }

    var headers: Headers<HeadersImplementation> { get }

    var status: Int { get }

    var url: URL { get }

    var bodyUsed: Bool { get async }
}

extension FetchResponse {

    public var ok: Bool {
        return status >= 200 && status <= 299
    }
}

extension FetchResponse {

    public func decode<T>(decoder: JSONDecoder = .init()) async throws -> T where T: Decodable & Sendable {
        return try await body.decode(decoder: decoder)
    }

    public func json() async throws -> Any {
        return try await body.json()
    }

    public func jsonObject() async throws -> [String: Any] {
        return try await body.jsonObject()
    }

    public func jsonArray() async throws -> [Any] {
        return try await body.jsonArray()
    }

    public func formValues() async throws -> [String: String] {
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
