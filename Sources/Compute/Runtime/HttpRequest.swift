//
//  HttpRequest.swift
//  
//
//  Created by Andrew Barba on 1/13/22.
//

import ComputeRuntime
import Foundation

internal struct HttpRequest {

    internal let handle: RequestHandle

    internal init(_ handle: RequestHandle) {
        self.handle = handle
    }

    public init() throws {
        var handle: RequestHandle = 0
        try wasi(fastly_http_req__new(&handle))
        self.handle = handle
    }

    public func method() throws -> HttpMethod? {
        let text = try wasiString(maxBufferLength: maxMethodLength) {
            fastly_http_req__method_get(handle, $0, $1, &$2)
        }
        return HttpMethod(rawValue: text ?? "")
    }

    public func method(_ newValue: HttpMethod) throws {
        let text = newValue.rawValue
        try wasi(fastly_http_req__method_set(handle, text, .init(text.utf8.count)))
    }

    public func uri() throws -> String? {
        return try wasiString(maxBufferLength: maxUriLength) {
            fastly_http_req__uri_get(handle, $0, $1, &$2)
        }
    }

    public func uri(_ newValue: String) throws {
        try wasi(fastly_http_req__uri_set(handle, newValue, .init(newValue.utf8.count)))
    }

    public func httpVersion() throws -> HttpVersion? {
        var version: Int32 = 0
        try wasi(fastly_http_req__version_get(handle, &version))
        return HttpVersion(rawValue: version)
    }

    public func httpVersion(_ newValue: HttpVersion) throws {
        try wasi(fastly_http_req__version_set(handle, newValue.rawValue))
    }

    public func close() throws {
        try wasi(fastly_http_req__close(handle))
    }
}
