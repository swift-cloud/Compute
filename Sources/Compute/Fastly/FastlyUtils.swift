//
//  Utils.swift
//
//
//  Created by Andrew Barba on 1/12/22.
//

import Foundation

internal typealias WasiBufferReader = (
    _ buffer: UnsafeMutablePointer<UInt8>?, _ maxLength: Int, _ length: inout Int
) -> Int32

internal func wasi(
    _ handler: @autoclosure () -> Int32,
    functionName: String = #function,
    fileName: String = #file
) throws {
    let result = handler()
    guard let status = WasiStatus(rawValue: result) else {
        throw Fastly.Error(status: .unexpected, functionName: functionName, fileName: fileName)
    }
    guard status == .ok else {
        throw Fastly.Error(status: status, functionName: functionName, fileName: fileName)
    }
}

internal func wasiString(
    maxBufferLength: Int,
    handler: WasiBufferReader,
    functionName: String = #function,
    fileName: String = #file
) throws -> String? {
    do {
        let bytes = try wasiBytes(
            maxBufferLength: maxBufferLength, handler: handler, functionName: functionName,
            fileName: fileName)
        return String(bytes: bytes, encoding: .utf8)
    } catch WasiStatus.none, WasiStatus.invalidArgument {
        return nil
    } catch {
        throw error
    }
}

internal func wasiDecode<T>(
    maxBufferLength: Int,
    decoder: JSONDecoder = Utils.jsonDecoder,
    handler: WasiBufferReader,
    functionName: String = #function,
    fileName: String = #file
) throws -> T where T: Decodable {
    let bytes = try wasiBytes(
        maxBufferLength: maxBufferLength, handler: handler, functionName: functionName,
        fileName: fileName)
    return try decoder.decode(T.self, from: Data(bytes))
}

internal func wasiBytes(
    maxBufferLength: Int,
    handler: WasiBufferReader,
    functionName: String = #function,
    fileName: String = #file
) throws -> [UInt8] {
    return try [UInt8](unsafeUninitializedCapacity: maxBufferLength) {
        var length = 0
        try wasi(
            handler($0.baseAddress, maxBufferLength, &length), functionName: functionName,
            fileName: fileName)
        $1 = length
    }
}

internal struct Utils {

    internal static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}

extension Array {

    internal func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

extension DataProtocol {

    internal var hex: String {
        return self.map { String(format: "%02x", $0) }.joined(separator: "")
    }
}

extension CharacterSet {

    static let javascriptURLAllowed: CharacterSet =
        .alphanumerics.union(.init(charactersIn: "-_.!~*'()"))  // as per RFC 3986
}
