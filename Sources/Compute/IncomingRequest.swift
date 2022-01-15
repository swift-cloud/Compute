//
//  IncomingRequest.swift
//  
//
//  Created by Andrew Barba on 1/13/22.
//

import ComputeRuntime
import Foundation

public struct IncomingRequest {

    internal let request: HttpRequest

    public let headers: Headers

    public let body: HttpBody

    public var method: HttpMethod {
        return (try? request.method()) ?? .get
    }

    public let url: URL

    public var httpVersion: HttpVersion {
        return (try? request.httpVersion()) ?? .http1_1
    }

    public var clientIp: IpAddress? {
        guard let octets = try? request.clientIp() else {
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

    internal init() throws {
        var requestHandle: RequestHandle = 0
        var bodyHandle: BodyHandle = 0
        try wasi(fastly_http_req__body_downstream_get(&requestHandle, &bodyHandle))
        let request = HttpRequest(requestHandle)
        self.request = request
        self.body = HttpBody(bodyHandle)
        self.headers = Headers(request: request)
        self.url = URL(string: try request.uri() ?? "http://localhost")!
    }
}

extension IncomingRequest {

    public struct Headers {

        internal let request: HttpRequest

        internal init(request: HttpRequest) {
            self.request = request
        }

        public func get(_ name: String) -> String? {
            return try? request.getHeader(name)
        }

        public func has(_ name: String) -> Bool {
            guard let value = get(name) else {
                return false
            }
            return value.count > 0
        }

        public subscript(name: String) -> String? {
            get { get(name) }
        }
    }
}
