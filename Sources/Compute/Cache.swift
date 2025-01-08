//
//  Cache.swift
//
//
//  Created by Andrew Barba on 9/13/23.
//

public struct Cache: Sendable {

    public static func getOrSet(
        _ key: String, _ handler: () async throws -> (FetchResponse, CachePolicy)
    ) async throws -> Entry {
        let trx = try await Fastly.Cache.getOrSet(key) {
            let (res, cachePolicy) = try await handler()
            let length = res.headers[.contentLength].flatMap(Int.init)
            return await (.body(res.body.body, length: length), cachePolicy)
        }
        return try .init(trx)
    }

    public static func getOrSet(_ key: String, _ handler: () async throws -> ([UInt8], CachePolicy))
        async throws -> Entry
    {
        let trx = try await Fastly.Cache.getOrSet(key) {
            let (bytes, cachePolicy) = try await handler()
            return (.bytes(bytes), cachePolicy)
        }
        return try .init(trx)
    }

    public static func getOrSet(_ key: String, _ handler: () async throws -> (String, CachePolicy))
        async throws -> Entry
    {
        let trx = try await Fastly.Cache.getOrSet(key) {
            let (text, cachePolicy) = try await handler()
            return (.bytes(.init(text.utf8)), cachePolicy)
        }
        return try .init(trx)
    }

    public static func getOrSet(_ key: String, _ handler: () async throws -> (Data, CachePolicy))
        async throws -> Entry
    {
        let trx = try await Fastly.Cache.getOrSet(key) {
            let (data, cachePolicy) = try await handler()
            return (.bytes(data.bytes), cachePolicy)
        }
        return try .init(trx)
    }

    public static func getOrSet(
        _ key: String, _ handler: () async throws -> ([String: Sendable], CachePolicy)
    ) async throws -> Entry {
        let trx = try await Fastly.Cache.getOrSet(key) {
            let (json, cachePolicy) = try await handler()
            let data = try JSONSerialization.data(withJSONObject: json)
            return (.bytes(data.bytes), cachePolicy)
        }
        return try .init(trx)
    }

    public static func getOrSet(
        _ key: String, _ handler: () async throws -> ([Sendable], CachePolicy)
    ) async throws -> Entry {
        let trx = try await Fastly.Cache.getOrSet(key) {
            let (json, cachePolicy) = try await handler()
            let data = try JSONSerialization.data(withJSONObject: json)
            return (.bytes(data.bytes), cachePolicy)
        }
        return try .init(trx)
    }
}

extension Cache {

    public struct Entry: Sendable {

        public let body: ReadableBody

        public let age: Int

        public let hits: Int

        public let contentLength: Int

        public let state: CacheState

        internal init(_ trx: Fastly.Cache.Transaction) throws {
            self.body = try ReadableWasiBody(trx.getBody())
            self.age = try trx.getAge()
            self.hits = try trx.getHits()
            self.contentLength = try trx.getLength()
            self.state = try trx.getState()
        }
    }
}
