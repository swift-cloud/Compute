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

    public var method: HttpMethod? {
        get {
            let string = try? wasiString {
                fastly_http_req__method_get(handle, $0, $1, &$2)
            }
            return HttpMethod(rawValue: string ?? "")
        }
        set {
            try? wasi(fastly_http_req__method_set(handle, newValue?.rawValue, .init(newValue?.rawValue.utf8.count ?? 0)))
        }
    }

    public var uri: String? {
        get {
            try? wasiString {
                fastly_http_req__uri_get(handle, $0, $1, &$2)
            }
        }
        set {
            try? wasi(fastly_http_req__uri_set(handle, newValue, .init(newValue?.utf8.count ?? 0)))
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
        set {
            try? wasi(fastly_http_req__version_set(handle, newValue?.rawValue ?? 0))
        }
    }

    internal init(_ handle: RequestHandle) {
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
