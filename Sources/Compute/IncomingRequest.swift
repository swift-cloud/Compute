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

    public var method: HttpMethod {
        request.method ?? .get
    }

    public var url: URL {
        URL(string: request.uri ?? "http://localhost")!
    }

    public var httpVersion: HttpVersion {
        request.httpVersion ?? .http1_1
    }

    public let body: HttpBody

    internal init() throws {
        var requestHandle: RequestHandle = 0
        var bodyHandle: BodyHandle = 0
        try wasi(fastly_http_req__body_downstream_get(&requestHandle, &bodyHandle))
        self.request = HttpRequest(requestHandle)
        self.body = HttpBody(bodyHandle)
    }
}
