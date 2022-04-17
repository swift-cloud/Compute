//
//  FetchResponse.swift
//  
//
//  Created by Andrew Barba on 1/14/22.
//

import Foundation

public struct FetchResponse: Sendable {

    internal let request: FetchRequest

    internal let response: Response

    public let body: ReadableBody

    public let headers: Headers<Response>

    public let status: Int

    public var ok: Bool {
        return status >= 200 && status <= 299
    }

    public var url: URL {
        return request.url
    }

    public var bodyUsed: Bool {
        get async {
            await body.used
        }
    }

    internal init(request: FetchRequest, response: Response, body: Body) throws {
        self.request = request
        self.response = response
        self.body = ReadableBody(body)
        self.headers = Headers(response)
        self.status = try .init(response.getStatus())
    }
}

extension FetchResponse {

    public func decode<T>(_ type: T.Type, decoder: JSONDecoder = .init()) async throws -> T where T: Decodable & Sendable {
        return try await body.decode(type, decoder: decoder)
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
