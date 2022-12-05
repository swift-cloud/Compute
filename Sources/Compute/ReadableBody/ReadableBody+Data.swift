//
//  ReadableBody+Data.swift
//  
//
//  Created by Andrew Barba on 12/5/22.
//

internal actor ReadableDataBody: ReadableBody {

    var used: Bool {
        return true
    }

    private(set) var body: Data

    init(_ body: Data) {
        self.body = body
    }

    func close() throws {}
}

extension ReadableDataBody {

    func pipeTo(_ dest: isolated WritableBody, preventClose: Bool) async throws {
        try dest.write(body)
    }
}

extension ReadableDataBody {

    func decode<T>(decoder: JSONDecoder = .init()) async throws -> T where T: Decodable & Sendable {
        return try decoder.decode(T.self, from: body)
    }

    func json() async throws -> Sendable {
        return try JSONSerialization.jsonObject(with: body)
    }

    func jsonObject() async throws -> [String : Sendable] {
        return try JSONSerialization.jsonObject(with: body) as! [String: Any]
    }

    func jsonArray() async throws -> [Sendable] {
        return try JSONSerialization.jsonObject(with: body) as! [Any]
    }

    func formValues() async throws -> [String: String] {
        let query = try await text()
        let components = URLComponents(string: "?\(query)")
        let queryItems = components?.queryItems ?? []
        return queryItems.reduce(into: [:]) { values, item in
            values[item.name] = item.value
        }
    }

    func text() async throws -> String {
        return String(data: body, encoding: .utf8)!
    }

    func data() async throws -> Data {
        return body
    }

    func bytes() async throws -> [UInt8] {
        return body.bytes
    }
}
