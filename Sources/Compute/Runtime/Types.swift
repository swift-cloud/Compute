//
//  Types.swift
//  
//
//  Created by Andrew Barba on 1/12/22.
//

import ComputeRuntime

public typealias WasiHandle = Int32

public enum WasiStatus: Int32, Error, CaseIterable {
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

public enum HttpVersion: Int32 {
    case http0_9 = 0
    case http1_0
    case http1_1
    case h2
    case h3
}

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case query = "QUERY"
}

public enum HttpHeader: String {
    case accept = "accept"
    case acceptEncoding = "accept-encoding"
    case acceptRanges = "accept-ranges"
    case age = "age"
    case cacheControl = "cache-control"
    case connection = "connection"
    case contentLength = "content-length"
    case contentRange = "content-range"
    case contentType = "content-type"
    case date = "date"
    case etag = "etag"
    case host = "host"
    case lastModified = "last-modified"
    case pragma = "pragma"
    case range = "range"
    case referer = "referer"
    case server = "server"
    case userAgent = "user-agent"
    case via = "via"
    case xCache = "x-cache"
}

public typealias HttpStatus = Int

public enum BodyWriteEnd: Int32 {
    case back = 0
    case front
}

public enum IpAddress {
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

public enum CachePolicy {
    case origin
    case pass
    case ttl(_ seconds: Int, staleWhileRevalidate: Int = 0, pciCompliant: Bool = false)
}

public typealias HeaderCount = Int32

public typealias IsDone = Int32

public typealias DoneIndex = Int32

public enum ContentEncodings: Int32 {
    case gzip = 1
}

public enum BodyScanContinuation {
    case `continue`
    case `break`
}

public let maxHeaderLength = 4096

public let maxMethodLength = 1024

public let maxUriLength = 4096

public let maxIpLookupLength = 2048

public let maxDictionaryEntryLength = 8000

public let highWaterMark = 4096
