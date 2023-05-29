//
//  FastlyWorld.swift
//  
//
//  Created by Andrew Barba on 5/29/23.
//

import FastlyWorld

public enum FastlyError: UInt8, Error, CaseIterable, Codable, Sendable {
    /// Unknown error
    /// This indicates that an unknown error occured
    case unknown = 0

    /// Generic error value.
    /// This means that some unexpected error occurred during a hostcall.
    case generic = 1

    /// Invalid argument.
    case invalidArgument = 2

    /// Invalid handle.
    /// Thrown when a handle is not valid. E.G. No dictionary exists with the given name.
    case invalidHandle = 3

    /// Buffer length error.
    /// Thrown when a buffer is too long.
    case bufferLength = 4

    /// Unsupported operation error.
    /// This error is thrown when some operation cannot be performed, because it is not supported.
    case unsupported = 5

    /// Alignment error.
    /// This is thrown when a pointer does not point to a properly aligned slice of memory.
    case badAlignment = 6

    /// Invalid HTTP error.
    /// This can be thrown when a method, URI, header, or status is not valid. This can also
    /// be thrown if a message head is too large.
    case httpInvalid = 7

    /// HTTP user error.
    /// This is thrown in cases where user code caused an HTTP error. For example, attempt to send
    /// a 1xx response code, or a request with a non-absolute URI. This can also be caused by
    /// an unexpected header: both `content-length` and `transfer-encoding`, for example.
    case httpUser = 8

    /// HTTP incomplete message error.
    /// This can be thrown when a stream ended unexpectedly.
    case httpIncomplete = 9

    /// A `None` error.
    /// This status code is used to indicate when an optional value did not exist, as opposed to
    /// an empty value.
    /// Note, this value should no longer be used, as we have explicit optional types now.
    case none = 10

    /// Message head too large.
    case httpHeadTooLarge = 11

    /// Invalid HTTP status.
    case httpInvalidStatus = 12

    /// Limit exceeded
    ///
    /// This is returned when an attempt to allocate a resource has exceeded the maximum number of
    /// resources permitted. For example, creating too many response handles.
    case limitExceeded = 13
}

internal func fastlyWorld(
    _ handler: (inout fastly_error_t) -> Bool
) throws {
    var error: fastly_error_t = 0
    guard handler(&error) else {
        throw FastlyError(rawValue: error) ?? .unknown
    }
}

extension fastly_option_bool_t {

    internal var value: Bool? {
        guard is_some else {
            return nil
        }
        return val
    }
}

extension fastly_world_string_t {

    internal var value: String {
        return String(cString: self.ptr, encoding: .utf8)!
    }
}

extension fastly_option_string_t {

    internal var value: String? {
        guard is_some else {
            return nil
        }
        return val.value
    }
}

extension fastly_list_string_t {

    internal var value: [String] {
        return .init(unsafeUninitializedCapacity: self.len) { buffer, written in
            for i in 0..<self.len {
                buffer[i] = self.ptr[i].value
            }
            written = self.len
        }
    }
}

extension String {

    internal var fastly_world_t: fastly_world_string_t {
        var str = fastly_world_string_t()
        fastly_world_string_set(&str, self)
        return str
    }
}

extension Array where Element == String {

    internal var fastly_world_t: fastly_list_string_t {
        var items = self.map { $0.fastly_world_t }
        return items.withUnsafeMutableBufferPointer {
            fastly_list_string_t(ptr: $0.baseAddress, len: self.count)
        }
    }
}

extension UnsafeBufferPointer where Element == UInt8 {

    internal var fastly_world_t: fastly_list_u8_t {
        let ptr = UnsafeMutablePointer(mutating: self.baseAddress)
        return fastly_list_u8_t(ptr: ptr, len: self.count)
    }
}

extension UnsafeMutableBufferPointer where Element == UInt8 {

    internal var fastly_world_t: fastly_list_u8_t {
        return fastly_list_u8_t(ptr: self.baseAddress, len: self.count)
    }
}
