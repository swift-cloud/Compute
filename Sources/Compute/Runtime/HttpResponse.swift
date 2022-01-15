//
//  HttpResponse.swift
//  
//
//  Created by Andrew Barba on 1/13/22.
//

import ComputeRuntime

public struct HttpResponse {

    internal let handle: ResponseHandle

    internal init(_ handle: ResponseHandle) {
        self.handle = handle
    }

    public init() throws {
        var handle: ResponseHandle = 0
        try wasi(fastly_http_resp__new(&handle))
        self.handle = handle
    }

    public func status() throws -> HttpStatus {
        var status: Int32 = 0
        try wasi(fastly_http_resp__status_get(handle, &status))
        return .init(status)
    }

    public func status(_ newValue: HttpStatus) throws {
        try wasi(fastly_http_resp__status_set(handle, .init(newValue)))
    }

    public func httpVersion() throws -> HttpVersion? {
        var version: Int32 = 0
        try wasi(fastly_http_resp__version_get(handle, &version))
        return HttpVersion(rawValue: version)
    }

    public func httpVersion(_ newValue: HttpVersion) throws {
        try wasi(fastly_http_resp__version_set(handle, newValue.rawValue))
    }

    public func send(_ body: HttpBody, streaming: Bool = false) throws {
        try wasi(fastly_http_resp__send_downstream(handle, body.handle, Int32(streaming ? 1 : 0)))
    }

    public func getHeader(_ name: String) throws -> String? {
        try wasiString(maxBufferLength: maxHeaderLength) {
            fastly_http_resp__header_value_get(handle, name, name.utf8.count, $0, $1, &$2)
        }
    }

    public func insertHeader(_ name: String, _ value: String) throws {
        try wasi(fastly_http_resp__header_insert(handle, name, name.utf8.count, value, value.utf8.count))
    }

    public func appendHeader(_ name: String, _ value: String) throws {
        try wasi(fastly_http_resp__header_append(handle, name, name.utf8.count, value, value.utf8.count))
    }

    public func removeHeader(_ name: String) throws {
        try wasi(fastly_http_resp__header_remove(handle, name, name.utf8.count))
    }

    public func close() throws {
        try wasi(fastly_http_resp__close(handle))
    }
}
