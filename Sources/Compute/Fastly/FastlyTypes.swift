//
//  Types.swift
//
//
//  Created by Andrew Barba on 1/12/22.
//

import ComputeRuntime

public typealias WasiHandle = UInt32

public let InvalidWasiHandle = UInt32.max - 1

public enum WasiStatus: Int32, Error, CaseIterable, Codable, Sendable {
    /// Success value.
    /// This indicates that a hostcall finished successfully.
    case ok = 0

    /// Generic error value.
    /// This means that some unexpected error occurred during a hostcall.
    case unexpected = 1

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

public enum HTTPVersion: Int32, Codable, Sendable {
    case http0_9 = 0
    case http1_0
    case http1_1
    case h2
    case h3

    public var stringValue: String {
        switch self {
        case .http0_9:
            return "0.9"
        case .http1_0:
            return "1.0"
        case .http1_1:
            return "1.1"
        case .h2:
            return "2"
        case .h3:
            return "3"
        }
    }

    public var name: String {
        return "http/\(stringValue)"
    }
}

public enum HTTPMethod: String, Codable, Sendable, CaseIterable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case query = "QUERY"
}

public typealias HTTPHeaders = [String: String]

public typealias HTTPSearchParams = [String: String]

public protocol HTTPHeaderRepresentable {

    var stringValue: String { get }
}

extension String: HTTPHeaderRepresentable {

    public var stringValue: String {
        self
    }
}

public enum HTTPHeader: String, HTTPHeaderRepresentable, Codable, Sendable {
    case accept = "accept"
    case acceptCharset = "accept-charset"
    case acceptEncoding = "accept-encoding"
    case acceptLanguage = "accept-language"
    case acceptRanges = "accept-ranges"
    case accessControlAllowCredentials = "access-control-allow-credentials"
    case accessControlAllowHeaders = "access-control-allow-headers"
    case accessControlAllowMethods = "access-control-allow-methods"
    case accessControlAllowOrigin = "access-control-allow-origin"
    case accessControlExposeHeaders = "access-control-expose-headers"
    case accessControlMaxAge = "access-control-max-age"
    case altSvc = "alt-svc"
    case age = "age"
    case authorization = "authorization"
    case cacheControl = "cache-control"
    case connection = "connection"
    case connectionId = "connection-id"
    case contentDisposition = "content-disposition"
    case contentEncoding = "content-encoding"
    case contentLanguage = "content-language"
    case contentLength = "content-length"
    case contentRange = "content-range"
    case contentSecurityPolicy = "content-security-policy"
    case contentType = "content-type"
    case cookie = "cookie"
    case crossOriginResourcePolicy = "cross-origin-resource-policy"
    case date = "date"
    case etag = "etag"
    case expires = "expires"
    case fastlyCacheKey = "fastly-xqd-cache-key"
    case forwarded = "forwarded"
    case from = "from"
    case gripChannel = "grip-channel"
    case gripHold = "grip-hold"
    case gripKeepAlive = "grip-keep-alive"
    case gripSig = "grip-sig"
    case gripTimeout = "grip-timeout"
    case host = "host"
    case keepAlive = "keep-alive"
    case lastModified = "last-modified"
    case link = "link"
    case location = "location"
    case pragma = "pragma"
    case range = "range"
    case referer = "referer"
    case refererPolicy = "referer-policy"
    case server = "server"
    case secWebSocketExtensions = "sec-websocket-extensions"
    case setCookie = "set-cookie"
    case surrogateControl = "surrogate-control"
    case surrogateKey = "surrogate-key"
    case trailer = "trailer"
    case transferEncoding = "transfer-encoding"
    case upgrade = "upgrade"
    case userAgent = "user-agent"
    case vary = "vary"
    case via = "via"
    case xCache = "x-cache"
    case xCacheHits = "x-cache-hits"
    case xCompressHint = "x-compress-hint"
    case xForwardedFor = "x-forwarded-for"

    public var stringValue: String {
        rawValue
    }
}

public enum HTTPStatus: Int, Codable, Sendable {

    // Informational
    case `continue` = 100
    case switchingProtocols = 101
    case processing = 102

    // Success
    case ok = 200
    case created = 201
    case accepted = 202
    case nonAuthoritativeInformation = 203
    case noContent = 204
    case resetContent = 205
    case partialContent = 206
    case multiStatus = 207
    case alreadyReported = 208
    case imUsed = 209

    // Redirection
    case multipleChoices = 300
    case movedPermanently = 301
    case found = 302
    case seeOther = 303
    case notModified = 304
    case useProxy = 305
    case switchProxy = 306
    case temporaryRedirect = 307
    case permanentRedirect = 308

    // Client error
    case badRequest = 400
    case unauthorised = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case proxyAuthenticationRequired = 407
    case requestTimeout = 408
    case conflict = 409
    case gone = 410
    case lengthRequired = 411
    case preconditionFailed = 412
    case requestEntityTooLarge = 413
    case requestURITooLong = 414
    case unsupportedMediaType = 415
    case requestedRangeNotSatisfiable = 416
    case expectationFailed = 417
    case iamATeapot = 418
    case authenticationTimeout = 419
    case methodFailureSpringFramework = 420
    case enhanceYourCalmTwitter = 4200
    case unprocessableEntity = 422
    case locked = 423
    case failedDependency = 424
    case methodFailureWebDaw = 4240
    case unorderedCollection = 425
    case upgradeRequired = 426
    case preconditionRequired = 428
    case tooManyRequests = 429
    case requestHeaderFieldsTooLarge = 431
    case noResponseNginx = 444
    case retryWithMicrosoft = 449
    case blockedByWindowsParentalControls = 450
    case redirectMicrosoft = 451
    case unavailableForLegalReasons = 4510
    case requestHeaderTooLargeNginx = 494
    case certErrorNginx = 495
    case noCertNginx = 496
    case httpToHttpsNginx = 497
    case clientClosedRequestNginx = 499

    // Server error
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case httpVersionNotSupported = 505
    case variantAlsoNegotiates = 506
    case insufficientStorage = 507
    case loopDetected = 508
    case bandwidthLimitExceeded = 509
    case notExtended = 510
    case networkAuthenticationRequired = 511
    case connectionTimedOut = 522
    case networkReadTimeoutErrorUnknown = 598
    case networkConnectTimeoutErrorUnknown = 599
}

public enum BodyWriteEnd: Int32, Sendable {
    case back = 0
    case front
}

public enum KeepAliveMode: UInt32, Sendable {
    case automatic = 0
    case disabled
}

public enum IPAddress: Sendable {
    case v4(String)
    case v6(String)

    public var stringValue: String {
        switch self {
        case .v4(let text):
            return text
        case .v6(let text):
            return text
        }
    }

    public static var localhost: IPAddress {
        .v4("127.0.0.1")
    }
}

public typealias MultiValueCursor = Int32

public typealias MultiValueCursorResult = Int64

public typealias HeaderCount = Int32

public typealias IsDone = Int32

public typealias DoneIndex = Int32

public enum ContentEncodings: UInt32, Sendable {
    case gzip = 1

    public var stringValue: String {
        switch self {
        case .gzip:
            return "gzip"
        }
    }
}

public enum FramingHeadersMode: UInt32, Sendable {
    case automatic = 0
    case manuallyFromHeaders = 1
}

public enum TLSVersion: Int, Sendable {
    case v1 = 0
    case v1_1 = 1
    case v1_2 = 2
    case v1_3 = 3
}

public enum BodyScanContinuation: Sendable {
    case `continue`
    case `break`
}

public struct BackendConfigOptions: OptionSet, Sendable {
    public static let reserved = BackendConfigOptions(rawValue: 1 << 0)
    public static let hostOverride = BackendConfigOptions(rawValue: 1 << 1)
    public static let connectTimeout = BackendConfigOptions(rawValue: 1 << 2)
    public static let firstByteTimeout = BackendConfigOptions(rawValue: 1 << 3)
    public static let betweenBytesTimeout = BackendConfigOptions(rawValue: 1 << 4)
    public static let useSSL = BackendConfigOptions(rawValue: 1 << 5)
    public static let sslMinVersion = BackendConfigOptions(rawValue: 1 << 6)
    public static let sslMaxVersion = BackendConfigOptions(rawValue: 1 << 7)
    public static let certHostname = BackendConfigOptions(rawValue: 1 << 8)
    public static let caCert = BackendConfigOptions(rawValue: 1 << 9)
    public static let ciphers = BackendConfigOptions(rawValue: 1 << 10)
    public static let sniHostname = BackendConfigOptions(rawValue: 1 << 11)

    public let rawValue: UInt32
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}

public struct CacheOverrideTag: OptionSet, Sendable {
    public static let pass = CacheOverrideTag(rawValue: 1 << 0)
    public static let ttl = CacheOverrideTag(rawValue: 1 << 1)
    public static let swr = CacheOverrideTag(rawValue: 1 << 2)
    public static let pci = CacheOverrideTag(rawValue: 1 << 3)

    public static let none: CacheOverrideTag = []

    public let rawValue: UInt32
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}

public struct CacheState: OptionSet, Sendable {
    public static let found = CacheState(rawValue: 1 << 0)
    public static let usable = CacheState(rawValue: 1 << 1)
    public static let stale = CacheState(rawValue: 1 << 2)
    public static let mustInsertOrUpdate = CacheState(rawValue: 1 << 3)

    public static let none: CacheState = []

    public let rawValue: UInt8
    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
}

public enum CachePolicy: Sendable {
    case origin
    case pass
    case ttl(_ seconds: Int, staleWhileRevalidate: Int = 0, pciCompliant: Bool = false)

    public var maxAge: Int {
        switch self {
        case .origin:
            return 0
        case .pass:
            return 0
        case .ttl(let seconds, _, _):
            return seconds
        }
    }

    public var staleMaxAge: Int {
        switch self {
        case .origin:
            return 0
        case .pass:
            return 0
        case .ttl(_, let seconds, _):
            return seconds
        }
    }
}

public struct CacheWriteOptions: OptionSet, Sendable {
    public static let reserved = CacheWriteOptions(rawValue: 1 << 0)
    public static let requestHeaders = CacheWriteOptions(rawValue: 1 << 1)
    public static let varyRule = CacheWriteOptions(rawValue: 1 << 2)
    public static let initialAgeNs = CacheWriteOptions(rawValue: 1 << 3)
    public static let staleWhileRevalidateNs = CacheWriteOptions(rawValue: 1 << 4)
    public static let surrogateKeys = CacheWriteOptions(rawValue: 1 << 5)
    public static let length = CacheWriteOptions(rawValue: 1 << 6)
    public static let userMetadata = CacheWriteOptions(rawValue: 1 << 7)
    public static let sensitiveData = CacheWriteOptions(rawValue: 1 << 8)

    public static let none: CacheWriteOptions = []

    public let rawValue: UInt32
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}

public struct CacheLookupOptions: OptionSet, Sendable {
    public static let reserved = CacheLookupOptions(rawValue: 1 << 0)
    public static let requestHeaders = CacheLookupOptions(rawValue: 1 << 1)

    public static let none: CacheLookupOptions = []

    public let rawValue: UInt32
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}

public struct CacheGetBodyOptions: OptionSet, Sendable {
    public static let reserved = CacheLookupOptions(rawValue: 1 << 0)
    public static let from = CacheLookupOptions(rawValue: 1 << 1)
    public static let to = CacheLookupOptions(rawValue: 1 << 2)

    public static let none: CacheGetBodyOptions = []

    public let rawValue: UInt32
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}

public let maxHeaderLength = 69000

public let maxMethodLength = 1024

public let maxUriLength = 8192

public let maxIpLookupLength = 2048

public let maxDictionaryEntryLength = 8000

public let highWaterMark = 4096

public let fanoutPublicKey =
    """
    -----BEGIN PUBLIC KEY-----
    MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAECKo5A1ebyFcnmVV8SE5On+8G81Jy
    BjSvcrx4VLetWCjuDAmppTo3xM/zz763COTCgHfp/6lPdCyYjjqc+GM7sw==
    -----END PUBLIC KEY-----
    """
