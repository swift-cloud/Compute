//
//  Fetch.swift
//  
//
//  Created by Andrew Barba on 1/15/22.
//

import Foundation

public func fetch(_ url: URL, _ options: FetchRequest.Options = .options()) async throws -> FetchResponse {
    let request = try FetchRequest(url, options)
    return try await request.send()
}

public func fetch(_ urlPath: String, _ options: FetchRequest.Options = .options()) async throws -> FetchResponse {
    guard let url = URL(string: urlPath) else {
        throw FetchRequestError.invalidURL
    }
    let request = try FetchRequest(url, options)
    return try await request.send()
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
