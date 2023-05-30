//
//  FastlyWorld.swift
//  
//
//  Created by Andrew Barba on 5/29/23.
//

import FastlyWorld

internal func fastlyWorld(
    _ handler: (inout fastly_error_t) -> Bool,
    functionName: String = #function,
    fileName: String = #file
) throws {
    var error: fastly_error_t = 0
    guard handler(&error) else {
        throw Fastly.Error(.init(error), functionName: functionName, fileName: fileName)
    }
}

// MARK: - Booleans

extension fastly_world_option_bool_t {

    internal var value: Bool? {
        guard is_some else {
            return nil
        }
        return val
    }
}

// MARK: - Strings

extension fastly_world_string_t {

    internal var value: String {
        return String(cString: self.ptr, encoding: .utf8)!
    }

    internal var data: Data {
        let buffer = UnsafeBufferPointer(start: self.ptr, count: self.len)
        return Data(buffer: buffer)
    }

    internal init(_ str: UnsafePointer<CChar>!, _ str_len: Int) {
        self.init(ptr: .init(mutating: str), len: str_len)
    }
}

extension fastly_world_option_string_t {

    internal var value: String? {
        guard is_some else {
            return nil
        }
        return val.value
    }
}

extension String {

    internal var fastly_world_t: fastly_world_string_t {
        return .init(self, self.utf8.count)
    }
}

// MARK: - Bytes

extension fastly_world_list_u8_t {

    internal var data: Data {
        let buffer = UnsafeBufferPointer(start: self.ptr, count: self.len)
        return Data(buffer: buffer)
    }
}

// MARK: - Arrays

extension fastly_world_list_string_t {

    internal var value: [String] {
        return .init(unsafeUninitializedCapacity: self.len) { buffer, written in
            for i in 0..<self.len {
                buffer[i] = self.ptr[i].value
            }
            written = self.len
        }
    }
}

extension Array where Element == String {

    internal var fastly_world_t: fastly_world_list_string_t {
        var items = self.map { $0.fastly_world_t }
        return items.withUnsafeMutableBufferPointer {
            fastly_world_list_string_t(ptr: $0.baseAddress, len: self.count)
        }
    }
}

extension Array where Element == UInt8 {

    internal var fastly_world_t: fastly_world_list_u8_t {
        var items = self
        return items.withUnsafeMutableBufferPointer {
            fastly_world_list_u8_t(ptr: $0.baseAddress, len: self.count)
        }
    }
}

extension Array where Element == fastly_pending_request_handle_t {

    internal var fastly_world_t: fastly_world_list_pending_request_handle_t {
        var items = self
        return items.withUnsafeMutableBufferPointer {
            fastly_world_list_pending_request_handle_t(ptr: $0.baseAddress, len: self.count)
        }
    }
}

// MARK: - Buffers

extension UnsafeBufferPointer where Element == UInt8 {

    internal var fastly_world_t: fastly_world_list_u8_t {
        let ptr = UnsafeMutablePointer(mutating: self.baseAddress)
        return fastly_world_list_u8_t(ptr: ptr, len: self.count)
    }
}

extension UnsafeMutableBufferPointer where Element == UInt8 {

    internal var fastly_world_t: fastly_world_list_u8_t {
        return fastly_world_list_u8_t(ptr: self.baseAddress, len: self.count)
    }
}
