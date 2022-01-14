//
//  HttpResponseHeaders.swift
//  
//
//  Created by Andrew Barba on 1/14/22.
//

import ComputeRuntime

public struct HttpResponseHeaders {

    internal let handle: ResponseHandle

    internal init(_ handle: ResponseHandle) {
        self.handle = handle
    }

    public func get(_ name: String) throws -> String? {
        try wasiString(maxBufferLength: maxHeaderLength) {
            fastly_http_resp__header_value_get(handle, name, name.utf8.count, $0, $1, &$2)
        }
    }

    public func insert(_ name: String, _ value: String) throws {
        try wasi(fastly_http_resp__header_insert(handle, name, name.utf8.count, value, value.utf8.count))
    }

    public func append(_ name: String, _ value: String) throws {
        try wasi(fastly_http_resp__header_append(handle, name, name.utf8.count, value, value.utf8.count))
    }

    public func remove(_ name: String) throws {
        try wasi(fastly_http_resp__header_remove(handle, name, name.utf8.count))
    }
}
