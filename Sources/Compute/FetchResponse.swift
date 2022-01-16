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

    public private(set) var body: HttpBody

    public let headers: Headers<HttpResponse>

    public let status: HttpStatus

    public private(set) var bodyUsed: Bool = false

    public var ok: Bool {
        return status >= 200 && status <= 299
    }

    public var url: URL {
        return request.url
    }

    internal init(request: FetchRequest, response: HttpResponse, body: HttpBody) throws {
        self.request = request
        self.response = response
        self.body = body
        self.headers = Headers(response)
        self.status = try .init(response.getStatus())
    }
}

extension FetchResponse {

    private func assertBodyNotUsed() throws {
        defer { bodyUsed = true }
        guard bodyUsed == false else {
            throw FetchResponseError.bodyAlreadyUsed
        }
    }

    public func decode<T>(_ type: T.Type, decoder: JSONDecoder = .init()) async throws -> T where T: Decodable {
        try assertBodyNotUsed()
        return try await withCheckedThrowingContinuation { continuation in
            Task.detached(priority: .high) {
                do {
                    let doc = try self.body.decode(type, decoder: decoder)
                    continuation.resume(with: .success(doc))
                } catch {
                    continuation.resume(with: .failure(error))
                }
            }
        }
    }

    public func json() async throws -> Any {
        try assertBodyNotUsed()
        return try await withCheckedThrowingContinuation { continuation in
            Task.detached(priority: .high) {
                do {
                    let json = try self.body.json()
                    continuation.resume(with: .success(json))
                } catch {
                    continuation.resume(with: .failure(error))
                }
            }
        }
    }

    public func text() async throws -> String {
        try assertBodyNotUsed()
        return try await withCheckedThrowingContinuation { continuation in
            Task.detached(priority: .high) {
                do {
                    let text = try self.body.text()
                    continuation.resume(with: .success(text))
                } catch {
                    continuation.resume(with: .failure(error))
                }
            }
        }
    }

    public func data() async throws -> Data {
        try assertBodyNotUsed()
        return try await withCheckedThrowingContinuation { continuation in
            Task.detached(priority: .high) {
                do {
                    let data = try self.body.data()
                    continuation.resume(with: .success(data))
                } catch {
                    continuation.resume(with: .failure(error))
                }
            }
        }
    }

    public func bytes() async throws -> [UInt8] {
        try assertBodyNotUsed()
        return try await withCheckedThrowingContinuation { continuation in
            Task.detached(priority: .high) {
                do {
                    let bytes = try self.body.bytes()
                    continuation.resume(with: .success(bytes))
                } catch {
                    continuation.resume(with: .failure(error))
                }
            }
        }
    }
}
