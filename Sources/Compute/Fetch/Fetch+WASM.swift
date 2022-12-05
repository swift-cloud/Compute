//
//  Fetch.swift
//  
//
//  Created by Andrew Barba on 1/15/22.
//

import CryptoSwift

internal struct WASMFetcher {

    static func fetch(_ request: FetchRequest) async throws -> some FetchResponse {
        // Create underlying http request
        var httpRequest = try Fastly.Request()

        // Build url components from request url
        guard var urlComponents = URLComponents(string: request.url.absoluteString) else {
            throw FetchRequestError.invalidURL
        }

        // Set default scheme
        urlComponents.scheme = urlComponents.scheme ?? "http"

        // Set default host
        urlComponents.host = urlComponents.host ?? "localhost"

        // Set default query params
        urlComponents.queryItems = urlComponents.queryItems ?? []

        // Build search params
        for (key, value) in request.searchParams {
            urlComponents.queryItems?.append(.init(name: key, value: value))
        }

        // Parse final url
        guard let url = urlComponents.url else {
            throw FetchRequestError.invalidURL
        }

        // Set request resources
        try httpRequest.setUri(url.absoluteString)
        try httpRequest.setMethod(request.method)
        try httpRequest.setCachePolicy(request.cachePolicy, surrogateKey: request.surrogateKey)

        // Set content encodings
        if let encoding = request.acceptEncoding {
            try httpRequest.setAutoDecompressResponse(encodings: encoding)
            try httpRequest.insertHeader(HTTPHeader.acceptEncoding.rawValue, encoding.stringValue)
        }

        // Set default content type based on body
        if let contentType = request.body?.defaultContentType {
            let name = HTTPHeader.contentType.rawValue
            try httpRequest.insertHeader(name, request.headers[name] ?? contentType)
        }

        // Check for a custom cache key
        if let cacheKey = request.cacheKey {
            let hash = cacheKey.bytes.sha256().toHexString().uppercased()
            try httpRequest.insertHeader(HTTPHeader.fastlyCacheKey.rawValue, hash)
        }

        // Set headers
        for (key, value) in request.headers {
            try httpRequest.insertHeader(key, value)
        }

        // Build request body
        let writableBody = WritableBody(try .init())
        var streamingBody: ReadableBody? = nil

        // Write bytes to body
        switch request.body {
        case .bytes(let bytes):
            try await writableBody.write(bytes)
        case .data(let data):
            try await writableBody.write(data)
        case .text(let text):
            try await writableBody.write(text)
        case .json(let json):
            try await writableBody.write(json)
        case .stream(let readableBody):
            streamingBody = readableBody
        case .none:
            break
        }

        // Register the backend
        if Fastly.Environment.viceroy, request.backend != "localhost" {
            try registerDynamicBackend(request.backend, for: httpRequest, ssl: urlComponents.scheme == "https")
        }

        // Issue async request
        let pendingRequest: Fastly.PendingRequest
        if let streamingBody = streamingBody {
            pendingRequest = try await httpRequest.sendAsyncStreaming(writableBody.body, backend: request.backend)
            try await streamingBody.pipeTo(writableBody)
        } else {
            pendingRequest = try await httpRequest.sendAsync(writableBody.body, backend: request.backend)
        }

        while true {
            // Poll request to see if its done
            if let (response, body) = try pendingRequest.poll() {
                return try FetchWASMResponse(request: request, response: response, body: body)
            }

            // Sleep for a bit before polling
            try await Task.sleep(nanoseconds: 1_000_000)
        }
    }

    private static var dynamicBackends: Set<String> = []

    private static func registerDynamicBackend(_ backend: String, for request: Fastly.Request, ssl: Bool) throws {
        // Make sure we didn't already register the backend
        guard dynamicBackends.contains(backend) == false else {
            return
        }

        // Attempt to register the backend
        do {
            try request.registerDynamicBackend(name: backend, target: backend, options: .init(ssl: ssl))
        } catch WasiStatus.unexpected {
            // ignore
        } catch {
            throw error
        }

        // Mark the backend as registered
        dynamicBackends.insert(backend)
    }
}
