//
//  FetchResponse.swift
//
//
//  Created by Andrew Barba on 1/14/22.
//

#if !arch(wasm32)
public struct FetchResponse: Sendable {

    internal let data: Data

    internal let response: HTTPURLResponse

    public var body: Data {
        data
    }

    public var headers: [String: String] {
        response.allHeaderFields as! [String: String]
    }

    public var status: Int {
        response.statusCode
    }

    public var ok: Bool {
        return status >= 200 && status <= 299
    }

    public var url: URL {
        return response.url!
    }

    public var bodyUsed: Bool {
        true
    }

    internal init(data: Data, response: HTTPURLResponse) throws {
        self.data = data
        self.response = response
    }
}

extension FetchResponse {

    public func decode<T>(decoder: JSONDecoder = .init()) async throws -> T where T: Decodable & Sendable {
        return try decoder.decode(T.self, from: body)
    }

    public func json() async throws -> Any {
        return try JSONSerialization.jsonObject(with: body)
    }

    public func jsonObject() async throws -> [String: Any] {
        return try JSONSerialization.jsonObject(with: body) as! [String: Any]
    }

    public func jsonArray() async throws -> [Any] {
        return try JSONSerialization.jsonObject(with: body) as! [Any]
    }

    public func formValues() async throws -> [String: String] {
        let query = try await text()
        let components = URLComponents(string: "?\(query)")
        let queryItems = components?.queryItems ?? []
        return queryItems.reduce(into: [:]) { values, item in
            values[item.name] = item.value
        }
    }

    public func text() async throws -> String {
        return String(data: body, encoding: .utf8)!
    }

    public func data() async throws -> Data {
        return body
    }

    public func bytes() async throws -> [UInt8] {
        return body.bytes
    }
}
#endif
