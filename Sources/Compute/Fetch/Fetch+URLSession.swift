//
//  Fetch+URLSession.swift
//
//
//  Created by Andrew Barba on 1/15/22.
//

#if canImport(Foundation.URLSession)
import CryptoSwift

internal struct URLSessionFetcher {

    static func fetch(_ request: FetchRequest) async throws -> FetchResponse {
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
        var httpRequest = URLRequest(url: url)

        // Set request method
        httpRequest.httpMethod = request.method.rawValue

        // Set content encodings
        if let encoding = request.acceptEncoding {
            httpRequest.setValue(encoding.stringValue, forHTTPHeaderField: HTTPHeader.acceptEncoding.rawValue)
        }

        // Set default content type based on body
        if let contentType = request.body?.defaultContentType {
            let name = HTTPHeader.contentType.rawValue
            httpRequest.setValue(request.headers[name] ?? contentType, forHTTPHeaderField: name)
        }

        // Set headers
        for (key, value) in request.headers {
            httpRequest.setValue(value, forHTTPHeaderField: key)
        }

        // Write bytes to body
        switch request.body {
        case .bytes(let bytes):
            httpRequest.httpBody = Data(bytes)
        case .data(let data):
            httpRequest.httpBody = data
        case .text(let text):
            httpRequest.httpBody = Data(text.utf8)
        case .json(let json):
            httpRequest.httpBody = json
        case .stream:
            break
        case .none:
            break
        }

        let (data, response) = try await URLSession.shared.data(for: httpRequest)

        let urlResponse = response as! HTTPURLResponse

        return FetchResponse(
            body: ReadableDataBody(data),
            headers: Headers(urlResponse.allHeaderFields as! [String: String]),
            status: urlResponse.statusCode,
            url: url
        )
    }
}
#endif
