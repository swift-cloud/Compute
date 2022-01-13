//
//  HttpRequest.swift
//  
//
//  Created by Andrew Barba on 1/13/22.
//

import ComputeRuntime

public struct HttpRequest {

    private let handle: RequestHandle

    public var method: String? {
        get {
            try? wasiString {
                fastly_http_req__method_get(handle, $0, $1, &$2)
            }
        }
    }

    public var uri: String? {
        get {
            try? wasiString {
                fastly_http_req__uri_get(handle, $0, $1, &$2)
            }
        }
    }

    public var httpVersion: HttpVersion? {
        get {
            do {
                var version: Int32 = 0
                try wasi(fastly_http_req__version_get(handle, &version))
                return HttpVersion(rawValue: version)
            } catch {
                return nil
            }
        }
    }

    public init(_ handle: RequestHandle) {
        self.handle = handle
    }

    public init() throws {
        var handle: RequestHandle = 0
        try wasi(fastly_http_req__new(&handle))
        self.handle = handle
    }

    public func close() throws {
        try wasi(fastly_http_req__close(handle))
    }
}

public struct IncomingRequest {

    public let request: HttpRequest

    public let body: HttpBody

    public init() throws {
        var requestHandle: RequestHandle = 0
        var bodyHandle: BodyHandle = 0
        try wasi(fastly_http_req__body_downstream_get(&requestHandle, &bodyHandle))
        self.request = HttpRequest(requestHandle)
        self.body = HttpBody(bodyHandle)
    }
}
