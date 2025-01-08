//
//  FetchRequest.swift
//
//
//  Created by Andrew Barba on 1/14/22.
//

public enum FetchRequestError: Error, Sendable {
    case invalidURL
    case timeout
}

public struct FetchRequest: Sendable {

    public var url: URL

    public var backend: String

    public var method: HTTPMethod

    public var cachePolicy: CachePolicy

    public var cacheKey: String?

    public var surrogateKey: String?

    public var headers: HTTPHeaders

    public var searchParams: HTTPSearchParams

    public var body: Body?

    public var acceptEncoding: ContentEncodings? = nil

    public var timeoutInterval: TimeInterval? = nil

    public init(_ url: URL, _ options: Options = .options()) {
        self.url = url
        self.backend = options.backend ?? url.host ?? "localhost"
        self.method = options.method ?? .get
        self.cachePolicy = options.cachePolicy ?? .origin
        self.cacheKey = options.cacheKey
        self.surrogateKey = options.surrogateKey
        self.headers = options.headers ?? [:]
        self.searchParams = options.searchParams ?? [:]
        self.body = options.body
        self.acceptEncoding = options.acceptEncoding
        self.timeoutInterval = options.timeoutInterval
    }
}

extension FetchRequest {

    public struct Options {

        public var method: HTTPMethod? = nil

        public var body: Body? = nil

        public var headers: HTTPHeaders? = nil

        public var searchParams: HTTPSearchParams? = nil

        public var timeoutInterval: TimeInterval? = nil

        public var cachePolicy: CachePolicy? = nil

        public var cacheKey: String? = nil

        public var acceptEncoding: ContentEncodings? = nil

        public var surrogateKey: String? = nil

        public var backend: String? = nil

        public static func options(
            method: HTTPMethod? = nil,
            body: Body? = nil,
            headers: HTTPHeaders? = nil,
            searchParams: HTTPSearchParams? = nil,
            timeoutInterval: TimeInterval? = nil,
            cachePolicy: CachePolicy? = nil,
            cacheKey: String? = nil,
            acceptEncoding: ContentEncodings? = nil,
            surrogateKey: String? = nil,
            backend: String? = nil
        ) -> Options {
            return Options(
                method: method,
                body: body,
                headers: headers,
                searchParams: searchParams,
                timeoutInterval: timeoutInterval,
                cachePolicy: cachePolicy,
                cacheKey: cacheKey,
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

        public static func json<T>(_ value: T, encoder: JSONEncoder = .init()) throws -> Body
        where T: Encodable {
            let data = try encoder.encode(value)
            return Body.json(data)
        }

        public static func json(_ jsonObject: [String: Any]) throws -> Body {
            let data = try JSONSerialization.data(withJSONObject: jsonObject)
            return Body.json(data)
        }

        public static func json(_ jsonArray: [Any]) throws -> Body {
            let data = try JSONSerialization.data(withJSONObject: jsonArray)
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
