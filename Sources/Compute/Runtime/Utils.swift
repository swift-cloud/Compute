//
//  Utils.swift
//  
//
//  Created by Andrew Barba on 1/12/22.
//

import CoreFoundation
import Foundation

internal typealias WasiBufferReader = (_ buffer: UnsafeMutablePointer<UInt8>?, _ maxLength: Int, _ length: inout Int) -> Int32

internal func wasi(_ handler: @autoclosure () -> Int32) throws {
    let result = handler()
    if let status = WasiStatus(rawValue: result), status != .ok {
        throw status
    }
}

internal func wasiString(maxBufferLength: Int, _ handler: WasiBufferReader) throws -> String? {
    do {
        let bytes = try wasiBytes(maxBufferLength: maxBufferLength, handler)
        return String(bytes: bytes, encoding: .utf8)
    } catch WasiStatus.none, WasiStatus.invalidArgument {
        return nil
    } catch {
        throw error
    }
}

internal func wasiDecode<T>(
    _ type: T.Type,
    maxBufferLength: Int,
    decoder: JSONDecoder = Utils.jsonDecoder,
    handler: WasiBufferReader
) throws -> T where T: Decodable {
    let bytes = try wasiBytes(maxBufferLength: maxBufferLength, handler)
    return try decoder.decode(type, from: Data(bytes))
}

internal func wasiBytes(maxBufferLength: Int, _ handler: WasiBufferReader) throws -> [UInt8] {
    var length = 0
    try wasi(handler(nil, maxBufferLength, &length))
    guard length > 0 else {
        return []
    }
    return try Array<UInt8>(unsafeUninitializedCapacity: length) {
        try wasi(handler($0.baseAddress, length, &length))
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
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
