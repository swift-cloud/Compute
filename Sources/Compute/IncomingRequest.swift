//
//  IncomingRequest.swift
//  
//
//  Created by Andrew Barba on 1/13/22.
//

import Foundation

public struct IncomingRequest: Sendable {

    internal let request: Request

    public let headers: Headers<Request>

    public let searchParams: [String: String]

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
        let (request, body) = try Request.getDownstream()
        let url = URL(string: try request.getUri() ?? "http://localhost")!
        self.request = request
        self.body = ReadableBody(body)
        self.headers = Headers(request)
        self.url = url
        self.method = try request.getMethod() ?? .get
        self.httpVersion = try request.getHTTPVersion() ?? .http1_1
        self.searchParams = URLComponents(string: url.absoluteString)?
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
        let octets = (try? Request.downstreamClientIpAddress()) ?? []
        switch octets.count {
        case 4:
            return .v4(octets.map(String.init).joined(separator: "."))
        case 16:
            return .v6(octets.chunked(into: 2)
                .map { $0.map { .init(format: "%02X", $0) }.joined(separator: "") }
                .joined(separator: ":"))
        default:
            return .localhost
        }
    }
}

extension IncomingRequest {

    public enum UpgradeWebsocketBehavior {
        case proxy
        case fanout
    }

    public func isUpgradeWebsocketRequest() -> Bool {
        let connection = headers[.connection, default: ""].lowercased()
        let upgrade = headers[.upgrade, default: ""].lowercased()
        return connection.contains("upgrade") && upgrade.contains("websocket")
    }

    public func upgradeWebsocket(backend: String, behavior: UpgradeWebsocketBehavior) throws {
        switch behavior {
        case .proxy:
            try request.redirectToWebsocketProxy(backend: backend)
        case .fanout:
            try request.redirectToGripProxy(backend: backend)
        }
    }
}

extension IncomingRequest {

    public func clientFingerprint() -> String? {
        return try? Request.downstreamTLSJA3MD5()
    }
}
