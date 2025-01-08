//
//  Fetch.swift
//
//
//  Created by Andrew Barba on 12/5/22.
//

public func fetch(_ request: FetchRequest) async throws -> FetchResponse {
    #if !arch(wasm32)
        return try await URLSessionFetcher.fetch(request)
    #else
        return try await WasiFetcher.fetch(request)
    #endif
}

public func fetch(_ url: URL, _ options: FetchRequest.Options = .options()) async throws
    -> FetchResponse
{
    let request = FetchRequest(url, options)
    return try await fetch(request)
}

public func fetch(_ urlPath: String, _ options: FetchRequest.Options = .options()) async throws
    -> FetchResponse
{
    guard let url = URL(string: urlPath) else {
        throw FetchRequestError.invalidURL
    }
    let request = FetchRequest(url, options)
    return try await fetch(request)
}

public func fetch(
    _ request: IncomingRequest,
    origin: String,
    streaming: Bool = true,
    forwardedFor: Bool = true,
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

    // Check if request body has been used
    let bodyUsed = await request.body.used

    // Final request body
    let body: FetchRequest.Body

    // Decide body based on options and streaming
    if let _body = options.body {
        body = _body
    } else if streaming, bodyUsed == false {
        body = .stream(request.body)
    } else {
        body = try await .bytes(request.body.bytes())
    }

    // Copy the request headers
    var headers = options.headers ?? request.headers.dictionary()

    // Set the proxied IP address
    if forwardedFor, headers[HTTPHeader.xForwardedFor.rawValue] == nil {
        headers[HTTPHeader.xForwardedFor.rawValue] = request.clientIpAddress().stringValue
    }

    return try await fetch(
        url,
        .options(
            method: options.method ?? request.method,
            body: body,
            headers: headers,
            searchParams: options.searchParams ?? request.searchParams,
            timeoutInterval: options.timeoutInterval,
            cachePolicy: options.cachePolicy,
            surrogateKey: options.surrogateKey,
            backend: options.backend
        ))
}
