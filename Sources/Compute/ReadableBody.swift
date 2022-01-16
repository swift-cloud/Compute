//
//  ReadableBody.swift
//  
//
//  Created by Andrew Barba on 1/16/22.
//

import Foundation

public enum ReadableBodyError: Error {
    case invalidLockedRead
}

public actor ReadableBody {

    internal private(set) var body: HttpBody

    public private(set) var locked: Bool = false

    internal init(_ body: HttpBody) {
        self.body = body
    }

    internal init(_ bodyHandle: BodyHandle) {
        self.body = .init(bodyHandle)
    }

    public func close() throws {
        try body.close()
    }

    private func lock() -> Bool {
        guard locked == false else {
            return false
        }
        locked = true
        return true
    }

    private func unlock() {
        locked = false
    }

    private func read(highWaterMark: Int, onChunk: ([UInt8]) -> BodyScanContinuation) throws {
        try body.read(highWaterMark: highWaterMark, onChunk: onChunk)
    }
}

extension ReadableBody {

    public func pipeTo(_ dest: WritableBody, preventClose: Bool = false) async throws {
        for try await chunk in byteStream() {
            try await dest.write(chunk)
        }
        if preventClose == false {
            try await dest.close()
        }
    }
}

extension ReadableBody {

    public func decode<T>(_ type: T.Type, decoder: JSONDecoder = .init()) async throws -> T where T: Decodable {
        let data = try await data()
        return try decoder.decode(type, from: data)
    }

    public func json() async throws -> Any {
        let data = try await data()
        return try JSONSerialization.jsonObject(with: data, options: [])
    }

    public func text() async throws -> String {
        let data = try await data()
        return String(data: data, encoding: .utf8) ?? ""
    }

    public func data() async throws -> Data {
        let bytes = try await bytes()
        return Data(bytes)
    }

    public func bytes() async throws -> [UInt8] {
        var bytes: [UInt8] = []
        for try await chunk in byteStream() {
            bytes.append(contentsOf: chunk)
        }
        return bytes
    }

    public func byteStream(highWaterMark: Int = highWaterMark) -> AsyncThrowingStream<[UInt8], Error> {
        return .init { continuation in
            do {
                guard lock() == true else {
                    throw ReadableBodyError.invalidLockedRead
                }
                try read(highWaterMark: highWaterMark) { chunk in
                    continuation.yield(chunk)
                    return .continue
                }
            } catch {
                continuation.finish(throwing: error)
            }
            unlock()
        }
    }
}
