//
//  File.swift
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

    internal init() throws {
        var requestHandle: RequestHandle = 0
        var bodyHandle: BodyHandle = 0
        try wasi(fastly_http_req__body_downstream_get(&requestHandle, &bodyHandle))
        self.request = HttpRequest(requestHandle)
        self.body = HttpBody(bodyHandle)
    }
}
