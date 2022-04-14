//
//  Types.swift
//  
//
//  Created by Andrew Barba on 1/12/22.
//

import ComputeRuntime

public typealias WasiHandle = UInt32

public let InvalidWasiHandle = UInt32.max - 1

public enum WasiStatus: Int32, Error, CaseIterable, Sendable {
    case ok = 0
    case genericError
    case invalidArgument
    case badDescriptor
    case bufferTooSmall
    case unsupported
    case wrongAlignment
    case httpParserError
    case httpUserError
    case httpIncomplete
    case none
    case httpHeadTooLarge
    case httpInvalidStatus
}

public enum HTTPVersion: Int32, Sendable {
    case http0_9 = 0
    case http1_0
    case http1_1
    case h2
    case h3
}

public enum HTTPMethod: String, Sendable, CaseIterable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case query = "QUERY"
}

public protocol HTTPHeaderRepresentable {

    var stringValue: String { get }
}

extension String: HTTPHeaderRepresentable {

    public var stringValue: String {
        self
    }
}

public enum HTTPHeader: String, HTTPHeaderRepresentable, Sendable {
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
    case forwarded = "forwarded"
    case from = "from"
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

    public var stringValue: String {
        rawValue
    }
}

public enum HTTPStatus: Int, Sendable {

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

public typealias BodyHandle = WasiHandle

public typealias RequestHandle = WasiHandle

public typealias ResponseHandle = WasiHandle

public typealias PendingRequestHandle = WasiHandle

public typealias EndpointHandle = WasiHandle

public typealias DictionaryHandle = WasiHandle

public typealias StoreHandle = WasiHandle

public typealias MultiValueCursor = Int32

public typealias MultiValueCursorResult = Int64

public typealias CacheOverrideTag = UInt32

extension CacheOverrideTag {
    public static let none: Self = 1
    public static let pass: Self = 2
    public static let ttl: Self = 4
    public static let staleWhileRevalidate: Self = 8
    public static let pci: Self = 10
}

public enum CachePolicy: Sendable {
    case origin
    case pass
    case ttl(_ seconds: Int, staleWhileRevalidate: Int = 0, pciCompliant: Bool = false)
}

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

public enum BodyScanContinuation: Sendable {
    case `continue`
    case `break`
}

public let maxHeaderLength = 69000

public let maxMethodLength = 1024

public let maxUriLength = 8192

public let maxIpLookupLength = 2048

public let maxDictionaryEntryLength = 8000

public let highWaterMark = 4096

public let localStoreName = "__fastly-local-store"
