//
//  File.swift
//  
//
//  Created by Andrew Barba on 1/14/22.
//

import Foundation

public enum FetchRequestError: Error {
    case invalidURL
}

public struct FetchRequest {

    public var url: URL

    public var backend: String

    public var method: HttpMethod = .get

    public var cachePolicy: CachePolicy = .origin

    public var surrogateKey: String? = nil

    public var headers: [String: String] = [:]

    public var body: HttpBody

    private let request: HttpRequest

    public init(_ url: URL, backend: String? = nil, method: HttpMethod = .get, cachePolicy: CachePolicy = .origin, surrogateKey: String? = nil, headers: [String: String] = [:], body: HttpBody? = nil) throws {
        let request = try HttpRequest()
        self.request = request
        self.url = url
        self.backend = backend ?? url.host ?? "localhost"
        self.method = method
        self.cachePolicy = cachePolicy
        self.surrogateKey = surrogateKey
        self.headers = headers
        self.body = try body ?? .init()
    }

    public func send() async throws -> FetchResponse {
        // Set request resources
        print("fetch:uri", url.absoluteString)
        try request.uri(url.absoluteString)
        print("fetch:method", method.rawValue)
        try request.method(method)
        print("fetch:httpVersion", "h2")
        try request.httpVersion(.h2)
        print("fetch:cachePolicy", cachePolicy)
        try request.cachePolicy(cachePolicy, surrogateKey: surrogateKey)

        // Set headers
        for (key, value) in headers {
            try HttpRequestHeaders(request.handle).insert(key, value)
        }

        // Issue async request
        print("fetch:backend", backend)
        let pendingRequest = try request.sendAsync(body, backend: backend)

        while true {
            // Poll request to see if its done
            if let (response, body) = try pendingRequest.poll() {
                let headers = HttpResponseHeaders(response.handle)
                return .init(response: response, headers: headers, body: body)
            }

            // Sleep for a bit before polling
            try await Task.sleep(nanoseconds: 4_000_000)
        }
    }
}

public struct FetchResponse {

    public let response: HttpResponse

    public let headers: HttpResponseHeaders

    public let body: HttpBody
}

public func fetch(_ url: URL, backend: String? = nil, method: HttpMethod = .get, cachePolicy: CachePolicy = .origin, surrogateKey: String? = nil, headers: [String: String] = [:], body: HttpBody? = nil) async throws -> FetchResponse {
    let request = try FetchRequest(url, backend: backend, method: method, cachePolicy: cachePolicy, surrogateKey: surrogateKey, headers: headers, body: body)
    return try await request.send()
}

public func fetch(_ urlPath: String, backend: String? = nil, method: HttpMethod = .get, cachePolicy: CachePolicy = .origin, surrogateKey: String? = nil, headers: [String: String] = [:], body: HttpBody? = nil) async throws -> FetchResponse {
    guard let url = URL(string: urlPath) else {
        throw FetchRequestError.invalidURL
    }
    let request = try FetchRequest(url, backend: backend, method: method, cachePolicy: cachePolicy, surrogateKey: surrogateKey, headers: headers, body: body)
    return try await request.send()
}
