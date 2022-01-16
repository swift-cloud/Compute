//
//  FetchRequest.swift
//  
//
//  Created by Andrew Barba on 1/14/22.
//

import Foundation

public enum FetchRequestError: Error {
    case invalidURL
}

public class FetchRequest {

    public var url: URL

    public var backend: String

    public var method: HttpMethod

    public var cachePolicy: CachePolicy

    public var surrogateKey: String?

    public var headers: [String: String?]

    public var searchParams: [String: String?]

    public var body: Body?

    private var request: HttpRequest

    public init(_ url: URL, _ options: Options = .options()) throws {
        let request = try HttpRequest()
        self.request = request
        self.url = url
        self.backend = options.backend ?? url.host ?? "localhost"
        self.method = options.method
        self.cachePolicy = options.cachePolicy
        self.surrogateKey = options.surrogateKey
        self.headers = options.headers
        self.searchParams = options.searchParams
        self.body = options.body
    }

    public func send() async throws -> FetchResponse {
        guard var urlComponents = URLComponents(string: url.absoluteString) else {
            throw FetchRequestError.invalidURL
        }

        // Set default query params
        urlComponents.queryItems = urlComponents.queryItems ?? []

        // Build search params
        for (key, value) in searchParams {
            guard let value = value else { continue }
            urlComponents.queryItems?.append(.init(name: key, value: value))
        }

        // Parse final url
        guard let url = urlComponents.url else {
            throw FetchRequestError.invalidURL
        }

        // Set request resources
        try request.setUri(url.absoluteString)
        try request.setMethod(method)
        try request.setCachePolicy(cachePolicy, surrogateKey: surrogateKey)

        // Set headers
        for (key, value) in headers {
            guard let value = value else { continue }
            try request.insertHeader(key, value)
        }

        // Build request body
        let writableBody = WritableBody(try HttpBody())
        var streamingBody: ReadableBody? = nil

        // Write bytes to body
        switch body {
        case .bytes(let bytes):
            try await writableBody.write(bytes)
        case .data(let data):
            try await writableBody.write(data)
        case .text(let text):
            try await writableBody.write(text)
        case .json(let json):
            try await writableBody.write(json)
        case .encode(let object):
            try await writableBody.write(object)
        case .stream(let readableBody):
            streamingBody = readableBody
        case .none:
            break
        }

        // Issue async request
        let pendingRequest: HttpPendingRequest
        if let streamingBody = streamingBody {
            pendingRequest = try await request.sendAsyncStreaming(writableBody.body, backend: backend)
            try await streamingBody.pipeTo(writableBody)
        } else {
            pendingRequest = try await request.sendAsync(writableBody.body, backend: backend)
        }

        while true {
            // Poll request to see if its done
            if let (response, body) = try pendingRequest.poll() {
                return try .init(request: self, response: response, body: body)
            }

            // Sleep for a bit before polling
            try await Task.sleep(nanoseconds: 4_000_000)
        }
    }
}

extension FetchRequest {

    public struct Options {

        public var method: HttpMethod = .get

        public var body: Body? = nil

        public var headers: [String: String?] = [:]

        public var searchParams: [String: String?] = [:]

        public var timeout: TimeInterval = .init(Int.max)

        public var cachePolicy: CachePolicy = .origin

        public var surrogateKey: String? = nil

        public var backend: String? = nil

        public static func options(
            method: HttpMethod = .get,
            body: Body? = nil,
            headers: [String: String?] = [:],
            searchParams: [String: String?] = [:],
            timeout: TimeInterval = .init(Int.max),
            cachePolicy: CachePolicy = .origin,
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
                surrogateKey: surrogateKey,
                backend: backend
            )
        }
    }
}

extension FetchRequest {

    public enum Body {
        case bytes(_ bytes: [UInt8])
        case data(_ data: Data)
        case text(_ text: String)
        case json(_ json: Any)
        case encode(_ object: Encodable)
        case stream(_ body: ReadableBody)
    }
}
