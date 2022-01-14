//
//  HttpRequestHeaders.swift
//  
//
//  Created by Andrew Barba on 1/14/22.
//

import ComputeRuntime

public struct HttpRequestHeaders {

    internal let handle: RequestHandle

    internal init(_ handle: RequestHandle) {
        self.handle = handle
    }

    public func get(_ name: String) throws -> String? {
        try wasiString(maxBufferLength: maxHeaderLength) {
            fastly_http_req__header_value_get(handle, name, name.utf8.count, $0, $1, &$2)
        }
    }

    public func insert(_ name: String, _ value: String) throws {
        try wasi(fastly_http_req__header_insert(handle, name, name.utf8.count, value, value.utf8.count))
    }

    public func append(_ name: String, _ value: String) throws {
        try wasi(fastly_http_req__header_append(handle, name, name.utf8.count, value, value.utf8.count))
    }

    public func remove(_ name: String) throws {
        try wasi(fastly_http_req__header_remove(handle, name, name.utf8.count))
    }
}
