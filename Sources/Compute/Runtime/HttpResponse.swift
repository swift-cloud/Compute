//
//  HttpResponse.swift
//  
//
//  Created by Andrew Barba on 1/13/22.
//

import ComputeRuntime

public struct HttpResponse: Sendable {

    internal let handle: ResponseHandle

    internal init(_ handle: ResponseHandle) {
        self.handle = handle
    }

    public init() throws {
        var handle: ResponseHandle = 0
        try wasi(fastly_http_resp__new(&handle))
        self.handle = handle
    }

    public func getStatus() throws -> HttpStatus {
        var status: Int32 = 0
        try wasi(fastly_http_resp__status_get(handle, &status))
        return .init(status)
    }

    public mutating func setStatus(_ newValue: HttpStatus) throws {
        try wasi(fastly_http_resp__status_set(handle, .init(newValue)))
    }

    public func getHttpVersion() throws -> HttpVersion? {
        var version: Int32 = 0
        try wasi(fastly_http_resp__version_get(handle, &version))
        return HttpVersion(rawValue: version)
    }

    public mutating func setHttpVersion(_ newValue: HttpVersion) throws {
        try wasi(fastly_http_resp__version_set(handle, newValue.rawValue))
    }

    public mutating func send(_ body: HttpBody, streaming: Bool = false) throws {
        try wasi(fastly_http_resp__send_downstream(handle, body.handle, Int32(streaming ? 1 : 0)))
    }

    public func getHeaderNames() throws -> [String] {
        var cursor: UInt32 = 0
        var nextCursor: Int64 = 0
        var bytes: [UInt8] = []
        while true {
            let chunk = try Array<UInt8>(unsafeUninitializedCapacity: 1024)  {
                try wasi(fastly_http_resp__header_names_get(handle, $0.baseAddress, 1024, cursor, &nextCursor, &$1))
            }
            guard chunk.count > 0 else {
                break
            }
            bytes.append(contentsOf: chunk)
            guard nextCursor >= 0 else {
                break
            }
            cursor = .init(nextCursor)
        }
        return bytes.split { $0 == 0 }.compactMap { String(bytes: $0, encoding: .utf8) }
    }

    public func getHeader(_ name: String) throws -> String? {
        try wasiString(maxBufferLength: maxHeaderLength) {
            fastly_http_resp__header_value_get(handle, name, name.utf8.count, $0, $1, &$2)
        }
    }

    public mutating func insertHeader(_ name: String, _ value: String) throws {
        try wasi(fastly_http_resp__header_insert(handle, name, name.utf8.count, value, value.utf8.count))
    }

    public mutating func appendHeader(_ name: String, _ value: String) throws {
        try wasi(fastly_http_resp__header_append(handle, name, name.utf8.count, value, value.utf8.count))
    }

    public mutating func removeHeader(_ name: String) throws {
        try wasi(fastly_http_resp__header_remove(handle, name, name.utf8.count))
    }

    public mutating func close() throws {
        try wasi(fastly_http_resp__close(handle))
    }

    public mutating func setFramingHeadersMode(_ newValue: FramingHeadersMode) throws {
        try wasi(fastly_http_resp__framing_headers_mode_set(handle, .init(newValue.rawValue)))
    }
}
