//
//  Fetch+URLSession.swift
//
//
//  Created by Andrew Barba on 1/15/22.
//

#if !arch(wasm32)
    internal struct URLSessionFetcher: Sendable {

        enum URLSessionFetchError: Error, Sendable {
            case invalidResponse
        }

        static func fetch(_ request: FetchRequest) async throws -> FetchResponse {
            // Build url components from request url
            guard var urlComponents = URLComponents(string: request.url.absoluteString) else {
                throw FetchRequestError.invalidURL
            }

            // Set default scheme
            urlComponents.scheme = urlComponents.scheme ?? "http"

            // Set default host
            urlComponents.host = urlComponents.host ?? "localhost"

            // Build search params
            for (key, value) in request.searchParams {
                var queryItems = urlComponents.queryItems ?? []
                queryItems.append(.init(name: key, value: value))
                urlComponents.queryItems = queryItems
            }

            // Parse final url
            guard let url = urlComponents.url else {
                throw FetchRequestError.invalidURL
            }

            // Set request resources
            var httpRequest = URLRequest(url: url)

            // Set request method
            httpRequest.httpMethod = request.method.rawValue

            // Set the timeout interval
            if let timeoutInterval = request.timeoutInterval {
                httpRequest.timeoutInterval = timeoutInterval
            }

            // Set content encodings
            if let encoding = request.acceptEncoding {
                httpRequest.setValue(
                    encoding.stringValue, forHTTPHeaderField: HTTPHeader.acceptEncoding.rawValue)
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
            case .stream(let body):
                let data = try await body.data()
                httpRequest.httpBodyStream = .init(data: data)
            case .none:
                break
            }

            let (data, response): (Data, HTTPURLResponse) =
                try await withCheckedThrowingContinuation { continuation in
                    let task = URLSession.shared.dataTask(with: httpRequest) {
                        data, response, error in
                        if let data, let response = response as? HTTPURLResponse {
                            continuation.resume(returning: (data, response))
                        } else {
                            continuation.resume(
                                throwing: error ?? URLSessionFetchError.invalidResponse)
                        }
                    }
                    task.resume()
                }

            return FetchResponse(
                body: ReadableDataBody(data),
                headers: Headers(response.allHeaderFields as! HTTPHeaders),
                status: response.statusCode,
                url: url
            )
        }
    }
#endif
