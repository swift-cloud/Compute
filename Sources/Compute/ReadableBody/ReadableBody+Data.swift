//
//  ReadableBody+Data.swift
//
//
//  Created by Andrew Barba on 12/5/22.
//

#if !arch(wasm32)
    internal actor ReadableDataBody: ReadableBody {

        var used: Bool {
            return true
        }

        var data: Data

        var body: Fastly.Body

        init(_ data: Data) {
            self.data = data
            self.body = .init(InvalidWasiHandle)
        }

        func close() async throws {}
    }

    extension ReadableDataBody {

        func pipeTo(_ dest: WritableBody, preventClose: Bool) async throws {
            try await dest.write(data)
        }
    }

    extension ReadableDataBody {

        func decode<T>(_ type: T.Type, decoder: JSONDecoder = .init()) async throws -> T
        where T: Decodable & Sendable {
            return try decoder.decode(type, from: data)
        }

        func json<T: Sendable>() async throws -> T {
            return try JSONSerialization.jsonObject(with: data) as! T
        }

        func jsonObject() async throws -> [String: Sendable] {
            return try await json()
        }

        func jsonArray() async throws -> [Sendable] {
            return try await json()
        }

        func formValues() async throws -> HTTPSearchParams {
            let query = try await text()
            let components = URLComponents(string: "?\(query)")
            let queryItems = components?.queryItems ?? []
            return queryItems.reduce(into: [:]) { values, item in
                values[item.name] = item.value
            }
        }

        func text() async throws -> String {
            return String(data: data, encoding: .utf8)!
        }

        func data() async throws -> Data {
            return data
        }

        func bytes() async throws -> [UInt8] {
            return data.bytes
        }
    }
#endif
