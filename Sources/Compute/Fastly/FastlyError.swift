//
//  FastlyError.swift
//  
//
//  Created by Andrew Barba on 1/31/23.
//

extension Fastly {
    public struct Error: Swift.Error, Sendable, Codable {
        public enum Code: UInt32, Codable, Sendable {
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

        public let code: Code

        public let functionName: String

        public let fileName: String

        internal var structName: String {
            fileName.components(separatedBy: "/").last!.components(separatedBy: ".").first!
        }

        internal init(_ codeValue: UInt32, functionName: String = #function, fileName: String = #file) {
            self.code = .init(rawValue: codeValue) ?? .unknown
            self.functionName = functionName
            self.fileName = fileName
        }

        internal init(_ code: Code, functionName: String = #function, fileName: String = #file) {
            self.code = code
            self.functionName = functionName
            self.fileName = fileName
        }
    }
}

extension Fastly.Error: LocalizedError {

    public var errorDescription: String? {
        return "\(structName).\(functionName): \(_errorDescription) - Fastly error code \(code.rawValue)"
    }

    internal var _errorDescription: String {
        switch code {

        case .unknown: return
            "Unknown error."

        case .generic: return
            "Generic error value. This means that some unexpected error " +
            "occurred during a hostcall."

        case .invalidArgument: return
            "Invalid argument."

        case .invalidHandle: return
            "Invalid handle. Thrown when a request, response, dictionary, or " +
            "body handle is not valid."

        case .bufferLength: return
            "Buffer length error. Buffer is too long."

        case .unsupported: return
            "Unsupported operation error. This error is thrown " +
            "when some operation cannot be performed, because it is " +
            "not supported."

        case .badAlignment: return
            "Alignment error. This is thrown when a pointer does not point to " +
            "a properly aligned slice of memory."

        case .httpInvalid: return
            "HTTP parse error. This can be thrown when a method, URI, header, " +
            "or status is not valid. This can also be thrown if a message head is " +
            "too large."

        case .httpUser: return
            "HTTP user error. This is thrown in cases where user code caused " +
            "an HTTP error. For example, attempt to send a 1xx response code, or a " +
            "request with a non-absolute URI. This can also be caused by an " +
            "unexpected header: both `content-length` and `transfer-encoding`, for " +
            "example."

        case .httpIncomplete: return
            "HTTP incomplete message error. A stream ended unexpectedly."

        case .none: return
            "A `None` error. This status code is used to " +
            "indicate when an optional value did not exist, as " +
            "opposed to an empty value."

        case .httpHeadTooLarge: return
            "HTTP head too large error. This error will be thrown when the " +
            "message head is too large."

        case .httpInvalidStatus: return
            "HTTP invalid status error. This error will be " +
            "thrown when the HTTP message contains an invalid " +
            "status code."

        case .limitExceeded: return
            "Limit exceeded error. This error will be thrown when an attempt " +
            "to allocate a resource has exceeded the maximum number of resources " +
            "permitted. For example, creating too many response handles."
        }
    }
}
