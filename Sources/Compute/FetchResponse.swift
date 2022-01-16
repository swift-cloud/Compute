//
//  FetchResponse.swift
//  
//
//  Created by Andrew Barba on 1/14/22.
//

import Foundation

public enum FetchResponseError: Error {
    case bodyAlreadyUsed
}

public class FetchResponse {

    internal let request: FetchRequest

    internal let response: HttpResponse

    public let body: ReadableBody

    public let headers: Headers<HttpResponse>

    public let status: HttpStatus

    public var ok: Bool {
        return status >= 200 && status <= 299
    }

    public var url: URL {
        return request.url
    }

    internal init(request: FetchRequest, response: HttpResponse, body: HttpBody) throws {
        self.request = request
        self.response = response
        self.body = ReadableBody(body)
        self.headers = Headers(response)
        self.status = try .init(response.getStatus())
    }
}

extension FetchResponse {

    public func decode<T>(_ type: T.Type, decoder: JSONDecoder = .init()) async throws -> T where T: Decodable {
        return try await body.decode(type, decoder: decoder)
    }

    public func json() async throws -> Any {
        return try await body.json()
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

    public func byteStream(highWaterMark: Int = highWaterMark) async -> AsyncThrowingStream<[UInt8], Error> {
        return await body.byteStream(highWaterMark: highWaterMark)
    }
}
