//
//  FastlyCache.swift
//
//
//  Created by Andrew Barba on 9/13/23.
//

import ComputeRuntime

extension Fastly {
    public struct Cache: Sendable {

        public typealias InsertResult = (data: HandlerData, cachePolicy: CachePolicy)

        public static func getOrSet(_ key: String, _ handler: () async throws -> InsertResult)
            async throws -> Transaction
        {
            // Open the transaction
            let trx = try Transaction.lookup(key)

            // Get current transaction state
            let state = try trx.getState()

            // If state is usable then return the body from cache
            guard state.contains(.mustInsertOrUpdate) else {
                return trx
            }

            do {
                // If its not usable then begin executing handler with new value
                let (data, cachePolicy) = try await handler()

                // Get an instance to the insert handle
                var writer = try trx.insertAndStreamBack(
                    cachePolicy: cachePolicy, length: data.length)

                // Append bytes from handler to writeable body
                switch data {
                case .body(let body, _):
                    try writer.body.append(body)
                case .bytes(let bytes):
                    try writer.body.write(bytes)
                }

                // Finish the body
                try writer.body.close()

                return writer.transaction
            } catch {
                // Cancel the transaction if something went wrong
                try trx.cancel()

                // Rethrow original error
                throw error
            }
        }
    }
}

extension Fastly.Cache {
    public enum HandlerData {
        case body(_ body: Fastly.Body, length: Int? = nil)
        case bytes(_ bytes: [UInt8])

        public var length: Int? {
            switch self {
            case .body(_, let length):
                return length
            case .bytes(let bytes):
                return bytes.count
            }
        }
    }
}

extension Fastly.Cache {
    public struct Transaction: Sendable {

        internal let handle: WasiHandle

        internal init(_ handle: WasiHandle) {
            self.handle = handle
        }

        public static func lookup(_ key: String) throws -> Transaction {
            var handle: WasiHandle = 0
            let options = CacheLookupOptions.none
            var config = CacheLookupConfig()
            try wasi(
                fastly_cache__cache_transaction_lookup(
                    key, key.utf8.count, options.rawValue, &config, &handle))
            return Transaction(handle)
        }

        public func insertAndStreamBack(cachePolicy: CachePolicy, length: Int?) throws -> (
            body: Fastly.Body, transaction: Transaction
        ) {
            var bodyHandle: WasiHandle = 0
            var cacheHandle: WasiHandle = 0
            var options: CacheWriteOptions = []
            var config = CacheWriteConfig()
            config.max_age_ns = .init(cachePolicy.maxAge) * 1_000_000_000
            if cachePolicy.staleMaxAge > 0 {
                options.insert(.staleWhileRevalidateNs)
                config.stale_while_revalidate_ns = .init(cachePolicy.staleMaxAge) * 1_000_000_000
            }
            if let length {
                options.insert(.length)
                config.length = .init(length)
            }
            try wasi(
                fastly_cache__cache_transaction_insert_and_stream_back(
                    handle, options.rawValue, &config, &bodyHandle, &cacheHandle))
            return (.init(bodyHandle), .init(cacheHandle))
        }

        public func getState() throws -> CacheState {
            var value: UInt8 = 0
            try wasi(fastly_cache__cache_get_state(handle, &value))
            return CacheState(rawValue: value)
        }

        public func getAge() throws -> Int {
            var value: UInt64 = 0
            try wasi(fastly_cache__cache_get_age_ns(handle, &value))
            return .init(value / 1_000_000_000)
        }

        public func getLength() throws -> Int {
            var value: UInt64 = 0
            try wasi(fastly_cache__cache_get_length(handle, &value))
            return .init(value)
        }

        public func getHits() throws -> Int {
            var value: UInt64 = 0
            try wasi(fastly_cache__cache_get_hits(handle, &value))
            return .init(value)
        }

        public func getBody() throws -> Fastly.Body {
            var bodyHandle: WasiHandle = 0
            let options = CacheGetBodyOptions.none
            var config = CacheGetBodyConfig()
            try wasi(fastly_cache__cache_get_body(handle, options.rawValue, &config, &bodyHandle))
            return .init(bodyHandle)
        }

        public func cancel() throws {
            try wasi(fastly_cache__cache_transaction_cancel(handle))
        }
    }
}
