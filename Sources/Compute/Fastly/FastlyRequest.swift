//
//  Request.swift
//
//
//  Created by Andrew Barba on 1/13/22.
//

import ComputeRuntime

extension Fastly {
    public struct Request: Sendable {

        internal let handle: WasiHandle

        internal init(_ handle: WasiHandle) {
            self.handle = handle
        }

        public init() throws {
            var handle: WasiHandle = 0
            try wasi(fastly_http_req__new(&handle))
            self.handle = handle
        }

        public func getMethod() throws -> HTTPMethod? {
            let text = try wasiString(maxBufferLength: maxMethodLength) {
                fastly_http_req__method_get(handle, $0, $1, &$2)
            }
            return HTTPMethod(rawValue: text ?? "")
        }

        public mutating func setMethod(_ newValue: HTTPMethod) throws {
            let text = newValue.rawValue
            try wasi(fastly_http_req__method_set(handle, text, text.utf8.count))
        }

        public func getUri() throws -> String? {
            return try wasiString(maxBufferLength: maxUriLength) {
                fastly_http_req__uri_get(handle, $0, $1, &$2)
            }
        }

        public mutating func setUri(_ newValue: String) throws {
            try wasi(fastly_http_req__uri_set(handle, newValue, newValue.utf8.count))
        }

        public func getHTTPVersion() throws -> HTTPVersion? {
            var version: Int32 = 0
            try wasi(fastly_http_req__version_get(handle, &version))
            return HTTPVersion(rawValue: version)
        }

        public mutating func setHTTPVersion(_ newValue: HTTPVersion) throws {
            try wasi(fastly_http_req__version_set(handle, newValue.rawValue))
        }

        public mutating func setAutoDecompressResponse(encodings: ContentEncodings) throws {
            try wasi(fastly_http_req__auto_decompress_response_set(handle, encodings.rawValue))
        }

        public mutating func setCachePolicy(_ policy: CachePolicy, surrogateKey: String? = nil)
            throws
        {
            var tag: CacheOverrideTag
            let ttl: UInt32
            let swr: UInt32
            switch policy {
            case .origin:
                tag = .none
                ttl = 0
                swr = 0
            case .pass:
                tag = .pass
                ttl = 0
                swr = 0
            case .ttl(let seconds, let staleWhileRevalidate, let pciCompliant):
                tag = .ttl.union(staleWhileRevalidate > 0 ? .swr : .none).union(
                    pciCompliant ? .pci : .none)
                ttl = .init(seconds)
                swr = .init(staleWhileRevalidate)
            }
            if let surrogateKey = surrogateKey {
                try wasi(
                    fastly_http_req__cache_override_v2_set(
                        handle, tag.rawValue, ttl, swr, surrogateKey, surrogateKey.utf8.count))
            } else {
                try wasi(fastly_http_req__cache_override_set(handle, tag.rawValue, ttl, swr))
            }
        }

        public func getHeaderNames() throws -> [String] {
            var cursor: UInt32 = 0
            var nextCursor: Int64 = 0
            var bytes: [UInt8] = []
            while true {
                let chunk = try [UInt8](unsafeUninitializedCapacity: 1024) {
                    try wasi(
                        fastly_http_req__header_names_get(
                            handle, $0.baseAddress, 1024, cursor, &nextCursor, &$1))
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
                fastly_http_req__header_value_get(handle, name, name.utf8.count, $0, $1, &$2)
            }
        }

        public mutating func insertHeader(_ name: String, _ value: String) throws {
            try wasi(
                fastly_http_req__header_insert(
                    handle, name, name.utf8.count, value, value.utf8.count))
        }

        public mutating func appendHeader(_ name: String, _ value: String) throws {
            try wasi(
                fastly_http_req__header_append(
                    handle, name, name.utf8.count, value, value.utf8.count))
        }

        public mutating func removeHeader(_ name: String) throws {
            try wasi(fastly_http_req__header_remove(handle, name, name.utf8.count))
        }

        public mutating func send(_ body: Body, backend: String) throws -> (
            response: Response, body: Body
        ) {
            var responseHandle: WasiHandle = 0
            var bodyHandle: WasiHandle = 0
            try wasi(
                fastly_http_req__send(
                    handle, body.handle, backend, backend.utf8.count, &responseHandle, &bodyHandle))
            return (.init(responseHandle), .init(bodyHandle))
        }

        public mutating func sendAsync(_ body: Body, backend: String) throws -> PendingRequest {
            var pendingRequestHandle: WasiHandle = 0
            try wasi(
                fastly_http_req__send_async(
                    handle, body.handle, backend, backend.utf8.count, &pendingRequestHandle))
            return .init(pendingRequestHandle, request: self)
        }

        public mutating func sendAsyncStreaming(_ body: Body, backend: String) throws
            -> PendingRequest
        {
            var pendingRequestHandle: WasiHandle = 0
            try wasi(
                fastly_http_req__send_async_streaming(
                    handle, body.handle, backend, backend.utf8.count, &pendingRequestHandle))
            return .init(pendingRequestHandle, request: self)
        }

        public mutating func close() throws {
            try wasi(fastly_http_req__close(handle))
        }

        public mutating func setFramingHeadersMode(_ newValue: FramingHeadersMode) throws {
            try wasi(fastly_http_req__framing_headers_mode_set(handle, newValue.rawValue))
        }

        public func redirectToWebsocketProxy(backend: String) throws {
            try wasi(fastly_http_req__redirect_to_websocket_proxy(backend, backend.utf8.count))
        }

        public func redirectToGripProxy(backend: String) throws {
            try wasi(fastly_http_req__redirect_to_grip_proxy(backend, backend.utf8.count))
        }
    }
}

extension Fastly.Request {

    public struct DynamicBackendOptions {
        public var connectTimeoutMs: Int
        public var firstByteTimeoutMs: Int
        public var betweenBytesTimeoutMs: Int
        public var ssl: Bool
        public var sslMinVersion: TLSVersion
        public var sslMaxVersion: TLSVersion

        public init(
            connectTimeoutMs: Int = 1_000,
            firstByteTimeoutMs: Int = 15_000,
            betweenBytesTimeoutMs: Int = 10_000,
            ssl: Bool = true,
            sslMinVersion: TLSVersion = .v1_1,
            sslMaxVersion: TLSVersion = .v1_3
        ) {
            self.connectTimeoutMs = connectTimeoutMs
            self.firstByteTimeoutMs = firstByteTimeoutMs
            self.betweenBytesTimeoutMs = betweenBytesTimeoutMs
            self.ssl = ssl
            self.sslMinVersion = sslMinVersion
            self.sslMaxVersion = sslMaxVersion
        }
    }

    public func registerDynamicBackend(
        name: String, target: String, options: DynamicBackendOptions = .init()
    ) throws {
        var mask: BackendConfigOptions = []

        var config = DynamicBackendConfig()

        // create target pointer used later
        try target.withCString { targetPointer in

            // host override
            mask.insert(.hostOverride)
            config.host_override = targetPointer
            config.host_override_len = target.utf8.count

            // connect timeout
            mask.insert(.connectTimeout)
            config.connect_timeout_ms = options.connectTimeoutMs

            // first byte timeout
            mask.insert(.firstByteTimeout)
            config.first_byte_timeout_ms = options.firstByteTimeoutMs

            // between bytes timeout
            mask.insert(.betweenBytesTimeout)
            config.between_bytes_timeout_ms = options.betweenBytesTimeoutMs

            // ssl
            if options.ssl {
                mask.insert(.useSSL)

                // ssl min version
                mask.insert(.sslMinVersion)
                config.ssl_min_version = options.sslMinVersion.rawValue

                // ssl max version
                mask.insert(.sslMaxVersion)
                config.ssl_max_version = options.sslMaxVersion.rawValue

                // cert hostname
                mask.insert(.certHostname)
                config.cert_hostname = targetPointer
                config.cert_hostname_len = target.utf8.count

                // sni hostname
                mask.insert(.sniHostname)
                config.sni_hostname = targetPointer
                config.sni_hostname_len = target.utf8.count
            }

            try wasi(
                fastly_http_req__register_dynamic_backend(
                    name,
                    name.utf8.count,
                    target,
                    target.utf8.count,
                    mask.rawValue,
                    &config
                ))
        }
    }
}

extension Fastly.Request {

    public static func getDownstream() throws -> (request: Self, body: Fastly.Body) {
        var requestHandle: WasiHandle = 0
        var bodyHandle: WasiHandle = 0
        try wasi(fastly_http_req__body_downstream_get(&requestHandle, &bodyHandle))
        let request = Self(requestHandle)
        let body = Fastly.Body(bodyHandle)
        return (request, body)
    }

    public static func originalHeaderCount() throws -> UInt32 {
        var count: UInt32 = 0
        try wasi(fastly_http_req__original_header_count(&count))
        return count
    }

    public static func originalHeaderNames() throws -> [String] {
        var cursor: UInt32 = 0
        var nextCursor: Int64 = 0
        var bytes: [UInt8] = []
        while true {
            let chunk = try [UInt8](unsafeUninitializedCapacity: 1024) {
                try wasi(
                    fastly_http_req__original_header_names_get(
                        $0.baseAddress, 1024, cursor, &nextCursor, &$1))
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
}

extension Fastly.Request {

    public static func downstreamClientIpAddress() throws -> [UInt8] {
        return try Array(unsafeUninitializedCapacity: 16) {
            var length = 0
            try wasi(fastly_http_req__downstream_client_ip_addr($0.baseAddress, &length))
            $1 = length
        }
    }
}

extension Fastly.Request {

    public static func downstreamTLSJA3MD5() throws -> [UInt8] {
        return try Array(unsafeUninitializedCapacity: 16) { buffer, length in
            try wasi(fastly_http_req__downstream_tls_ja3_md5(buffer.baseAddress, &length))
        }
    }

    public static func downstreamTLSJA4() throws -> String? {
        return try wasiString(maxBufferLength: 1024) {
            fastly_http_req__downstream_tls_ja4($0, $1, &$2)
        }
    }
}
