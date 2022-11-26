//
//  Fetch.swift
//  
//
//  Created by Andrew Barba on 1/15/22.
//

#if arch(wasm32)

import CryptoSwift
import Foundation

public func fetch(_ request: FetchRequest) async throws -> FetchResponse {
    // Create underlying http request
    var httpRequest = try Request()

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
        print("hashing cache key...")
        let hash = cacheKey.bytes.sha256().toHexString()
        print("hash \(hash)")
        try httpRequest.insertHeader(HTTPHeader.fastlyCacheKey.rawValue, hash)
        print("set cache header")
    }

    // Set headers
    for (key, value) in request.headers {
        try httpRequest.insertHeader(key, value)
    }

    // Build request body
    let writableBody = WritableBody(try Body())
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
    if Environment.Compute.viceroy, request.backend != "localhost" {
        try registerDynamicBackend(request.backend, for: httpRequest, ssl: urlComponents.scheme == "https")
    }

    // Issue async request
    print("Attempting request....")
    let pendingRequest: PendingRequest
    if let streamingBody = streamingBody {
        pendingRequest = try await httpRequest.sendAsyncStreaming(writableBody.body, backend: request.backend)
        try await streamingBody.pipeTo(writableBody)
    } else {
        pendingRequest = try await httpRequest.sendAsync(writableBody.body, backend: request.backend)
    }

    print("sent.")

    while true {
        // Poll request to see if its done
        if let (response, body) = try pendingRequest.poll() {
            print("response")
            return try .init(request: request, response: response, body: body)
        }

        // Sleep for a bit before polling
        try await Task.sleep(nanoseconds: 1_000_000)
    }
}

public func fetch(_ url: URL, _ options: FetchRequest.Options = .options()) async throws -> FetchResponse {
    let request = FetchRequest(url, options)
    return try await fetch(request)
}

public func fetch(_ urlPath: String, _ options: FetchRequest.Options = .options()) async throws -> FetchResponse {
    guard let url = URL(string: urlPath) else {
        throw FetchRequestError.invalidURL
    }
    let request = FetchRequest(url, options)
    return try await fetch(request)
}

public func fetch (
    _ request: IncomingRequest,
    origin: String,
    streaming: Bool = true,
    _ options: FetchRequest.Options = .options()
) async throws -> FetchResponse {
    guard
        let originComponents = URLComponents(string: origin),
        let host = originComponents.host,
        let scheme = originComponents.scheme
    else {
        throw FetchRequestError.invalidURL
    }

    guard var requestComponents = URLComponents(string: request.url.absoluteString) else {
        throw FetchRequestError.invalidURL
    }

    // Apply request components
    requestComponents.host = host
    requestComponents.scheme = scheme
    requestComponents.user = originComponents.user
    requestComponents.password = originComponents.password
    requestComponents.port = originComponents.port
    requestComponents.path = originComponents.path + requestComponents.path

    // Parse new url
    guard let url = requestComponents.url else {
        throw FetchRequestError.invalidURL
    }

    return try await fetch(url, .options(
        method: request.method,
        body: streaming ? .stream(request.body) : .bytes(request.body.bytes()),
        headers: request.headers.dictionary(),
        searchParams: request.searchParams,
        timeout: options.timeout,
        cachePolicy: options.cachePolicy,
        surrogateKey: options.surrogateKey,
        backend: options.backend
    ))
}

private var dynamicBackends: Set<String> = []

private func registerDynamicBackend(_ backend: String, for request: Request, ssl: Bool) throws {
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

#endif
