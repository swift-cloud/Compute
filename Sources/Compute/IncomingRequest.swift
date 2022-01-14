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

    public let body: HttpBody

    public var method: HttpMethod {
        return (try? request.method()) ?? .get
    }

    public var url: URL {
        return URL(string: (try? request.uri()) ?? "http://localhost")!
    }

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
        self.request = HttpRequest(requestHandle)
        self.body = HttpBody(bodyHandle)
    }
}
