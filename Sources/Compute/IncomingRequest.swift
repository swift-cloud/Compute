//
//  IncomingRequest.swift
//
//
//  Created by Andrew Barba on 1/13/22.
//

public struct IncomingRequest: Sendable {

    internal let request: Fastly.Request

    public let headers: Headers

    public let searchParams: HTTPSearchParams

    /// `pathParams` will only be set when used with a `Router`
    public internal(set) var pathParams: Parameters = .init()

    public let body: ReadableBody

    public let method: HTTPMethod

    public let url: URL

    public let httpVersion: HTTPVersion

    public var bodyUsed: Bool {
        get async {
            await body.used
        }
    }

    internal init() throws {
        let (request, body) = try Fastly.Request.getDownstream()
        let url = URL(string: try request.getUri() ?? "http://localhost")!
        self.request = request
        self.body = ReadableWasiBody(body)
        self.headers = Headers(request)
        self.url = url
        self.method = try request.getMethod() ?? .get
        self.httpVersion = try request.getHTTPVersion() ?? .http1_1
        self.searchParams =
            URLComponents(string: url.absoluteString)?
            .queryItems?
            .reduce(into: [:]) { $0[$1.name] = $1.value } ?? [:]
    }

    public func range() -> Range? {
        guard let value = headers[.range] else {
            return nil
        }
        return Range(from: value)
    }

    public func clientIpAddress() -> IPAddress {
        let octets = (try? Fastly.Request.downstreamClientIpAddress()) ?? []
        switch octets.count {
        case 4:
            return .v4(octets.map(String.init).joined(separator: "."))
        case 16:
            return .v6(octets.chunked(into: 2).map(\.hex).joined(separator: ":"))
        default:
            return .localhost
        }
    }
}

extension IncomingRequest {
    public enum TLSFingerprintMethod: Sendable {
        case ja3
        case ja4
    }

    public func TLSFingerprint(_ method: TLSFingerprintMethod) -> String? {
        switch method {
        case .ja3:
            return try? Fastly.Request.downstreamTLSJA3MD5().hex
        case .ja4:
            return try? Fastly.Request.downstreamTLSJA4()
        }
    }
}
