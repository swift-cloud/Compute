//
//  File.swift
//  
//
//  Created by Andrew Barba on 1/13/22.
//

import ComputeRuntime

public struct HttpResponse {

    internal let handle: ResponseHandle

    public var status: HttpStatus? {
        get {
            do {
                var status: Int32 = 200
                try wasi(fastly_http_resp__status_get(handle, &status))
                return status
            } catch {
                return nil
            }
        }
        set {
            try? wasi(fastly_http_resp__status_set(handle, newValue ?? 0))
        }
    }

    public var httpVersion: HttpVersion? {
        get {
            do {
                var version: Int32 = 0
                try wasi(fastly_http_resp__version_get(handle, &version))
                return HttpVersion(rawValue: version)
            } catch {
                return nil
            }
        }
        set {
            try? wasi(fastly_http_resp__version_set(handle, newValue?.rawValue ?? 0))
        }
    }

    internal init(_ handle: ResponseHandle) {
        self.handle = handle
    }

    public init() throws {
        var handle: ResponseHandle = 0
        try wasi(fastly_http_resp__new(&handle))
        self.handle = handle
    }

    public func send(_ body: HttpBody, streaming: Bool = false) throws {
        try wasi(fastly_http_resp__send_downstream(handle, body.handle, Int32(streaming ? 1 : 0)))
    }

    public func close() throws {
        try wasi(fastly_http_resp__close(handle))
    }
}
