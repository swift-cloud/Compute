//
//  FastlyCache.swift
//  
//
//  Created by Andrew Barba on 9/13/23.
//

import ComputeRuntime

extension Fastly {

    public struct Cache: Sendable {

        public static func getOrSet(_ key: String, _ handler: () async throws -> (FetchResponse, CachePolicy)) async throws -> ReadableBody {
            return try await getOrSet(key) {
                let (res, cachePolicy) = try await handler()
                guard let header = res.headers[.contentLength], let length = Int(header) else {
                    let bytes = try await res.bytes()
                    return (.bytes(bytes), cachePolicy)
                }
                return await (.body(res.body.body, length: length), cachePolicy)
            }
        }

        public static func getOrSet(_ key: String, _ handler: () async throws -> ([UInt8], CachePolicy)) async throws -> ReadableBody {
            return try await getOrSet(key) {
                let (bytes, cachePolicy) = try await handler()
                return (.bytes(bytes), cachePolicy)
            }
        }

        public static func getOrSet(_ key: String, _ handler: () async throws -> (String, CachePolicy)) async throws -> ReadableBody {
            return try await getOrSet(key) {
                let (text, cachePolicy) = try await handler()
                return (.bytes(.init(text.utf8)), cachePolicy)
            }
        }

        public static func getOrSet(_ key: String, _ handler: () async throws -> (Data, CachePolicy)) async throws -> ReadableBody {
            return try await getOrSet(key) {
                let (data, cachePolicy) = try await handler()
                return (.bytes(data.bytes), cachePolicy)
            }
        }

        public static func getOrSet(_ key: String, _ handler: () async throws -> ([String: Sendable], CachePolicy)) async throws -> ReadableBody {
            return try await getOrSet(key) {
                let (json, cachePolicy) = try await handler()
                let data = try JSONSerialization.data(withJSONObject: json)
                return (.bytes(data.bytes), cachePolicy)
            }
        }

        public static func getOrSet(_ key: String, _ handler: () async throws -> ([Sendable], CachePolicy)) async throws -> ReadableBody {
            return try await getOrSet(key) {
                let (json, cachePolicy) = try await handler()
                let data = try JSONSerialization.data(withJSONObject: json)
                return (.bytes(data.bytes), cachePolicy)
            }
        }
    }
}

extension Fastly.Cache {

    internal enum HandlerData {
        case body(_ body: Fastly.Body, length: Int)
        case bytes(_ bytes: [UInt8])

        var length: Int {
            switch self {
            case .body(_, let length):
                return length
            case .bytes(let bytes):
                return bytes.count
            }
        }
    }

    internal static func getOrSet(_ key: String, _ handler: () async throws -> (HandlerData, CachePolicy)) async throws -> ReadableBody {
        // Open the transaction
        let trx = try await Transaction.lookup(key)

        // Get current transaction state
        let state = try await trx.getState()

        // If state is usable then return the body from cache
        if state == .found || state == .usable {
            let body = try await trx.getBody()
            return ReadableWasiBody(body)
        }

        // If its not usable then begin executing handler with new value
        let (data, cachePolicy) = try await handler()

        // Get an instance to the insert handle
        var writer = try await trx.insertAndStreamBack(cachePolicy: cachePolicy, length: data.length)

        // Append bytes from handler to writeable body
        switch data {
        case .body(let body, _):
            try writer.body.append(body)
        case .bytes(let bytes):
            try writer.body.write(bytes)
        }

        // Get handle to reabable body out from cache
        return try await ReadableWasiBody(writer.transaction.getBody())
    }
}

extension Fastly.Cache {
    public struct Transaction: Sendable {

        internal let handle: WasiHandle

        internal init(_ handle: WasiHandle) {
            self.handle = handle
        }

        internal static func lookup(_ key: String) async throws -> Transaction {
            var handle: WasiHandle = 0
            let options = CacheLookupOptions.reserved
            var config = CacheLookupConfig()
            try wasi(fastly_cache__cache_transaction_lookup(key, key.utf8.count, options.rawValue, &config, &handle))
            return Transaction(handle)
        }

        internal func insertAndStreamBack(cachePolicy: CachePolicy, length: Int) async throws -> (body: Fastly.Body, transaction: Transaction) {
            var bodyHandle: WasiHandle = 0
            var cacheHandle: WasiHandle = 0
            let options: CacheWriteOptions = [.initialAgeNs, .staleWhileRevalidateNs, .length]
            var config = CacheWriteConfig()
            config.max_age_ns = .init(cachePolicy.maxAge) * 1_000_000_000
            config.stale_while_revalidate_ns = .init(cachePolicy.staleMaxAge) * 1_000_000_000
            config.length = .init(length)
            try wasi(fastly_cache__cache_transaction_insert_and_stream_back(handle, options.rawValue, &config, &bodyHandle, &cacheHandle))
            return (.init(bodyHandle), .init(cacheHandle))
        }

        internal func getState() async throws -> CacheState {
            var value: UInt8 = 0
            try wasi(fastly_cache__cache_get_state(handle, &value))
            return CacheState(rawValue: value)
        }

        internal func getBody() async throws -> Fastly.Body {
            var bodyHandle: WasiHandle = 0
            let options = CacheGetBodyOptions.reserved
            var config = CacheGetBodyConfig()
            try wasi(fastly_cache__cache_get_body(handle, options.rawValue, &config, &bodyHandle))
            return .init(bodyHandle)
        }

        internal func cancel() async throws {
            try wasi(fastly_cache__cache_transaction_cancel(handle))
        }
    }
}
