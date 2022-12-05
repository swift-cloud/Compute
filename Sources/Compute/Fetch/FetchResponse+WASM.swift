//
//  FetchResponse.swift
//  
//
//  Created by Andrew Barba on 1/14/22.
//

internal struct FetchWASMResponse: FetchResponse {

    let body: ReadableBody

    let headers: Headers<Fastly.Response>

    let status: Int

    let url: URL

    var bodyUsed: Bool {
        get async {
            await body.used
        }
    }

    init(request: FetchRequest, response: Fastly.Response, body: Fastly.Body) throws {
        self.url = request.url
        self.body = ReadableWASMBody(body)
        self.headers = Headers(response)
        self.status = try .init(response.getStatus())
    }
}
