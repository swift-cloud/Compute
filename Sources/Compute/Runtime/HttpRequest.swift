//
//  HttpRequest.swift
//  
//
//  Created by Andrew Barba on 1/13/22.
//

import ComputeRuntime
import Foundation

public struct HttpRequest {

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
        try wasi(fastly_http_req__method_set(handle, text, text.utf8.count))
    }

    public func uri() throws -> String? {
        return try wasiString(maxBufferLength: maxUriLength) {
            fastly_http_req__uri_get(handle, $0, $1, &$2)
        }
    }

    public func uri(_ newValue: String) throws {
        try wasi(fastly_http_req__uri_set(handle, newValue, newValue.utf8.count))
    }

    public func httpVersion() throws -> HttpVersion? {
        var version: Int32 = 0
        try wasi(fastly_http_req__version_get(handle, &version))
        return HttpVersion(rawValue: version)
    }

    public func httpVersion(_ newValue: HttpVersion) throws {
        try wasi(fastly_http_req__version_set(handle, newValue.rawValue))
    }

    public func clientIp() throws -> [UInt8] {
        return try Array<UInt8>(unsafeUninitializedCapacity: 16) {
            var length = 0
            try wasi(fastly_http_req__downstream_client_ip_addr($0.baseAddress, &length))
            $1 = length
        }
    }

    public func cachePolicy(_ policy: CachePolicy, surrogateKey: String? = nil) throws {
        var tag: CacheOverrideTag = .none
        var ttl: UInt32 = 0
        var swr: UInt32 = 0
        switch policy {
        case .origin:
            break
        case .pass:
            tag |= .pass
        case .ttl(let seconds, let staleWhileRevalidate):
            tag |= .ttl
            if staleWhileRevalidate > 0 {
                tag |= .staleWhileRevalidate
            }
            ttl = .init(seconds)
            swr = .init(staleWhileRevalidate)
        }
        if let surrogateKey = surrogateKey {
            try wasi(fastly_http_req__cache_override_v2_set(handle, tag, ttl, swr, surrogateKey, surrogateKey.utf8.count))
        } else {
            try wasi(fastly_http_req__cache_override_set(handle, tag, ttl, swr))
        }
    }

    public func send(_ body: HttpBody, backend: String) throws -> (response: HttpResponse, body: HttpBody) {
        var responseHandle: ResponseHandle = 0
        var bodyHandle: BodyHandle = 0
        try wasi(fastly_http_req__send(handle, body.handle, backend, backend.utf8.count, &responseHandle, &bodyHandle))
        return (.init(responseHandle), .init(bodyHandle))
    }

    public func sendAsync(_ body: HttpBody, backend: String) throws -> HttpPendingRequest {
        var handle: PendingRequestHandle = 0
        try wasi(fastly_http_req__send_async(handle, body.handle, backend, backend.utf8.count, &handle))
        return .init(handle, request: self)
    }

    public func sendAsyncStreaming(_ body: HttpBody, backend: String) throws -> HttpPendingRequest {
        var handle: PendingRequestHandle = 0
        try wasi(fastly_http_req__send_async_streaming(handle, body.handle, backend, backend.utf8.count, &handle))
        return .init(handle, request: self)
    }

    public func close() throws {
        try wasi(fastly_http_req__close(handle))
    }
}

public struct HttpPendingRequest {

    internal let handle: PendingRequestHandle

    public let request: HttpRequest

    internal init(_ handle: PendingRequestHandle, request: HttpRequest) {
        self.handle = handle
        self.request = request
    }

    internal func wait() throws -> (response: HttpResponse, body: HttpBody) {
        var responseHandle: ResponseHandle = 0
        var bodyHandle: BodyHandle = 0
        try wasi(fastly_http_req__pending_req_wait(handle, &responseHandle, &bodyHandle))
        return (.init(responseHandle), .init(bodyHandle))
    }

    internal func poll() throws -> (response: HttpResponse, body: HttpBody)? {
        var isDone: UInt32 = 0
        var responseHandle: ResponseHandle = 0
        var bodyHandle: BodyHandle = 0
        try wasi(fastly_http_req__pending_req_poll(handle, &isDone, &responseHandle, &bodyHandle))
        guard isDone > 0 else {
            return nil
        }
        return (.init(responseHandle), .init(bodyHandle))
    }

    internal static func select(_ requests: [HttpPendingRequest]) throws -> (index: Int, response: HttpResponse, body: HttpBody) {
        var handles = requests.map(\.handle)
        var doneIndex: UInt32 = 0
        var responseHandle: ResponseHandle = 0
        var bodyHandle: BodyHandle = 0
        try wasi(fastly_http_req__pending_req_select(&handles, handles.count, &doneIndex, &responseHandle, &bodyHandle))
        return (.init(doneIndex), .init(responseHandle), .init(bodyHandle))
    }
}
