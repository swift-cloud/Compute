//
//  FetchResponse.swift
//
//
//  Created by Andrew Barba on 1/14/22.
//

internal struct FetchURLSessionResponse: FetchResponse {

    let body: ReadableBody

    let headers: Headers<[String: String]>

    let status: Int

    let url: URL

    var bodyUsed: Bool {
        get async { true }
    }

    init(data: Data, response: HTTPURLResponse) {
        self.url = response.url!
        self.status = response.statusCode
        self.headers = .init(response.allHeaderFields as! [String: String])
        self.body = ReadableDataBody(data)
    }
}
