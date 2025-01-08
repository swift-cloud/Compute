//
//  ReadableBody+WASM.swift
//
//
//  Created by Andrew Barba on 1/16/22.
//

internal actor ReadableWasiBody: ReadableBody {

    var used: Bool {
        return body.used
    }

    private(set) var body: Fastly.Body

    private var _bytes: [UInt8]? = nil

    internal init(_ body: Fastly.Body) {
        self.body = body
    }

    internal init(_ bodyHandle: WasiHandle) {
        self.body = .init(bodyHandle)
    }

    func close() throws {
        try body.close()
    }
}

extension ReadableWasiBody {

    func pipeTo(_ dest: WritableBody, preventClose: Bool) async throws {
        var destBody = await dest.body
        try body.read {
            try destBody.write($0)
            return .continue
        }
        if preventClose == false {
            try destBody.close()
        }
    }
}

extension ReadableWasiBody {

    func decode<T>(_ type: T.Type, decoder: JSONDecoder = .init()) async throws -> T
    where T: Decodable {
        let data = try await data()
        return try decoder.decode(type, from: data)
    }

    func json<T: Sendable>() async throws -> T {
        let data = try await data()
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
        let data = try await data()
        return String(data: data, encoding: .utf8) ?? ""
    }

    func data() async throws -> Data {
        let bytes = try await bytes()
        return Data(bytes)
    }

    func bytes() async throws -> [UInt8] {
        // Check if we've already ready the bytes from this stream
        if let _bytes = _bytes {
            return _bytes
        }

        // Create new bytes array
        var bytes: [UInt8] = []

        // Scan all bytes into new bytes array
        try body.read { chunk in
            bytes.append(contentsOf: chunk)
            return .continue
        }

        // Save bytes for future reads
        _bytes = bytes

        // Return new bytes array
        return bytes
    }
}
