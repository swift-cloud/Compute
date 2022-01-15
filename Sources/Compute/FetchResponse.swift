//
//  File.swift
//  
//
//  Created by Andrew Barba on 1/14/22.
//

import Foundation

public struct FetchResponse {

    internal let request: FetchRequest

    internal let response: HttpResponse

    public let body: HttpBody

    public let headers: Headers

    public let status: Int

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
        self.headers = Headers(response: response)
        self.status = try .init(response.status())
    }
}

extension FetchResponse {

    public struct Headers {

        internal let response: HttpResponse

        internal init(response: HttpResponse) {
            self.response = response
        }

        public func get(_ name: String) -> String? {
            return try? response.getHeader(name)
        }

        public func has(_ name: String) -> Bool {
            guard let value = get(name) else {
                return false
            }
            return value.count > 0
        }

        public func set(_ name: String, _ value: String?) {
            if let value = value {
                try? response.insertHeader(name, value)
            } else {
                try? response.removeHeader(name)
            }
        }

        public func append(_ name: String, _ value: String) {
            try? response.appendHeader(name, value)
        }

        public func delete(_ name: String) {
            try? response.removeHeader(name)
        }
    }
}

extension FetchResponse {

    public func decode<T>(_ type: T.Type, decoder: JSONDecoder = .init()) async throws -> T where T: Decodable {
        try await withCheckedThrowingContinuation { continuation in
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
        try await withCheckedThrowingContinuation { continuation in
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
        try await withCheckedThrowingContinuation { continuation in
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
        try await withCheckedThrowingContinuation { continuation in
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
        try await withCheckedThrowingContinuation { continuation in
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
