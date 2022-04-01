//
//  Types.swift
//  
//
//  Created by Andrew Barba on 1/12/22.
//

import ComputeRuntime

public typealias WasiHandle = Int32

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

public enum HTTPMethod: String, Sendable {
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
    case userAgent = "user-agent"
    case vary = "vary"
    case via = "via"
    case xCache = "x-cache"

    public var stringValue: String {
        rawValue
    }
}

public typealias HTTPStatus = Int

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
