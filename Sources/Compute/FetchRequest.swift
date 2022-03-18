//
//  FetchRequest.swift
//  
//
//  Created by Andrew Barba on 1/14/22.
//

import Foundation

public enum FetchRequestError: Error, Sendable {
    case invalidURL
}

public struct FetchRequest: Sendable {

    public var url: URL

    public var backend: String

    public var method: HttpMethod

    public var cachePolicy: CachePolicy

    public var surrogateKey: String?

    public var headers: [String: String]

    public var searchParams: [String: String]

    public var body: Body?

    public var acceptEncoding: ContentEncodings? = nil

    public init(_ url: URL, _ options: Options = .options()) {
        self.url = url
        self.backend = options.backend ?? url.host ?? "localhost"
        self.method = options.method
        self.cachePolicy = options.cachePolicy
        self.surrogateKey = options.surrogateKey
        self.headers = options.headers
        self.searchParams = options.searchParams
        self.body = options.body
        self.acceptEncoding = options.acceptEncoding
    }
}

extension FetchRequest {

    public struct Options {

        public var method: HttpMethod = .get

        public var body: Body? = nil

        public var headers: [String: String] = [:]

        public var searchParams: [String: String] = [:]

        public var timeout: TimeInterval = .init(Int.max)

        public var cachePolicy: CachePolicy = .origin

        public var acceptEncoding: ContentEncodings? = nil

        public var surrogateKey: String? = nil

        public var backend: String? = nil

        public static func options(
            method: HttpMethod = .get,
            body: Body? = nil,
            headers: [String: String] = [:],
            searchParams: [String: String] = [:],
            timeout: TimeInterval = .init(Int.max),
            cachePolicy: CachePolicy = .origin,
            acceptEncoding: ContentEncodings? = nil,
            surrogateKey: String? = nil,
            backend: String? = nil
        ) -> Options {
            return Options(
                method: method,
                body: body,
                headers: headers,
                searchParams: searchParams,
                timeout: timeout,
                cachePolicy: cachePolicy,
                acceptEncoding: acceptEncoding,
                surrogateKey: surrogateKey,
                backend: backend
            )
        }
    }
}

extension FetchRequest {

    public enum Body: Sendable {
        case bytes(_ bytes: [UInt8])
        case data(_ data: Data)
        case text(_ text: String)
        case json(_ json: Data)
        case stream(_ body: ReadableBody)

        public static func json<T>(_ value: T, encoder: JSONEncoder = .init()) throws -> Body where T: Encodable {
            let data = try encoder.encode(value)
            return Body.json(data)
        }

        public static func json(_ jsonObject: [String: Any]) throws -> Body {
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            return Body.json(data)
        }

        public static func json(_ jsonArray: [Any]) throws -> Body {
            let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
            return Body.json(data)
        }

        public var defaultContentType: String? {
            switch self {
            case .json:
                return "application/json"
            default:
                return nil
            }
        }
    }
}
