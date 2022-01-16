//
//  IncomingRequest.swift
//  
//
//  Created by Andrew Barba on 1/13/22.
//

import ComputeRuntime
import Foundation

public class IncomingRequest {

    internal let request: HttpRequest

    public let headers: Headers<HttpRequest>

    public private(set) var body: HttpBody

    public private(set) var bodyUsed: Bool = false

    public let method: HttpMethod

    public let url: URL

    public let httpVersion: HttpVersion

    internal init() throws {
        var requestHandle: RequestHandle = 0
        var bodyHandle: BodyHandle = 0
        try wasi(fastly_http_req__body_downstream_get(&requestHandle, &bodyHandle))
        let request = HttpRequest(requestHandle)
        self.request = request
        self.body = HttpBody(bodyHandle)
        self.headers = Headers(request)
        self.url = URL(string: try request.getUri() ?? "http://localhost")!
        self.method = try request.getMethod() ?? .get
        self.httpVersion = try request.getHttpVersion() ?? .http1_1
    }

    public func clientIpAddress() -> IpAddress? {
        guard let octets = try? request.downstreamClientIpAddress() else {
            return nil
        }
        switch octets.count {
        case 4:
            return .v4(octets.map(String.init).joined(separator: "."))
        case 16:
            return .v6(octets.chunked(into: 2)
                .map { $0.map { String(format: "%02X", $0) }.joined(separator: "") }
                .joined(separator: ":"))
        default:
            return nil
        }
    }
}

extension IncomingRequest {

    public func decode<T>(_ type: T.Type, decoder: JSONDecoder = .init()) async throws -> T where T: Decodable {
        defer { bodyUsed = true }
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
        defer { bodyUsed = true }
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
        defer { bodyUsed = true }
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
        defer { bodyUsed = true }
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
        defer { bodyUsed = true }
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
