//
//  FastlyError.swift
//
//
//  Created by Andrew Barba on 1/31/23.
//

extension Fastly {
    public struct Error: Swift.Error, Sendable, Codable {
        public let status: WasiStatus
        public let functionName: String
        public let fileName: String

        internal var structName: String {
            fileName.components(separatedBy: "/").last!.components(separatedBy: ".").first!
        }

        internal init(
            status: WasiStatus, functionName: String = #function, fileName: String = #file
        ) {
            self.status = status
            self.functionName = functionName
            self.fileName = fileName
        }
    }
}

extension Fastly.Error: LocalizedError {

    public var errorDescription: String? {
        return
            "\(structName).\(functionName): \(status._errorDescription) - Fastly error code \(status.rawValue)"
    }
}

extension WasiStatus: LocalizedError {

    public var errorDescription: String? {
        return _errorDescription
    }

    internal var _errorDescription: String {
        switch self {

        case .ok:
            return
                "OK"

        case .unexpected:
            return
                "Generic error value. This means that some unexpected error "
                + "occurred during a hostcall."

        case .invalidArgument:
            return
                "Invalid argument."

        case .invalidHandle:
            return
                "Invalid handle. Thrown when a request, response, dictionary, or "
                + "body handle is not valid."

        case .bufferLength:
            return
                "Buffer length error. Buffer is too long."

        case .unsupported:
            return
                "Unsupported operation error. This error is thrown "
                + "when some operation cannot be performed, because it is " + "not supported."

        case .badAlignment:
            return
                "Alignment error. This is thrown when a pointer does not point to "
                + "a properly aligned slice of memory."

        case .httpInvalid:
            return
                "HTTP parse error. This can be thrown when a method, URI, header, "
                + "or status is not valid. This can also be thrown if a message head is "
                + "too large."

        case .httpUser:
            return
                "HTTP user error. This is thrown in cases where user code caused "
                + "an HTTP error. For example, attempt to send a 1xx response code, or a "
                + "request with a non-absolute URI. This can also be caused by an "
                + "unexpected header: both `content-length` and `transfer-encoding`, for "
                + "example."

        case .httpIncomplete:
            return
                "HTTP incomplete message error. A stream ended unexpectedly."

        case .none:
            return
                "A `None` error. This status code is used to "
                + "indicate when an optional value did not exist, as "
                + "opposed to an empty value."

        case .httpHeadTooLarge:
            return
                "HTTP head too large error. This error will be thrown when the "
                + "message head is too large."

        case .httpInvalidStatus:
            return
                "HTTP invalid status error. This error will be "
                + "thrown when the HTTP message contains an invalid " + "status code."

        case .limitExceeded:
            return
                "Limit exceeded error. This error will be thrown when an attempt "
                + "to allocate a resource has exceeded the maximum number of resources "
                + "permitted. For example, creating too many response handles."
        }
    }
}
