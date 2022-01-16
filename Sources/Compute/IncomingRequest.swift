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

    public let body: ReadableBody

    public let method: HttpMethod

    public let url: URL

    public let httpVersion: HttpVersion

    internal init() throws {
        var requestHandle: RequestHandle = 0
        var bodyHandle: BodyHandle = 0
        try wasi(fastly_http_req__body_downstream_get(&requestHandle, &bodyHandle))
        let request = HttpRequest(requestHandle)
        self.request = request
        self.body = ReadableBody(bodyHandle)
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
