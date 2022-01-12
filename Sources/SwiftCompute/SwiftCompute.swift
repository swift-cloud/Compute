import ComputeRuntime

public struct SwiftCompute {
    public private(set) var text = "Hello, World!"

    public init() {}
}

public typealias WasiHandle = Int32

public typealias Char8 = UInt8

public typealias Char32 = UInt32

public enum FastlyStatus: UInt32, CaseIterable {
    case ok = 0
    case error
    case invalidArgument
    case invalidHandle
    case bufferLengthError
    case unsupported
    case badAlignment
    case httpInvalidError
    case httpUserError
    case httpIncompleteError
    case none
    case httpHeadTooLarge
    case httpInvalidStatus
}

public enum FastlyError: Error, CaseIterable {
    case ok
    case error
    case invalidArgument
    case invalidHandle
    case bufferLengthError
    case unsupported
    case badAlignment
    case httpInvalidError
    case httpUserError
    case httpIncompleteError
    case none
    case httpHeadTooLarge
    case httpInvalidStatus

    init?(_ status: FastlyStatus) {
        guard status != .ok else {
            return nil
        }
        self = Self.allCases[Int(status.rawValue)]
    }

    init?<T>(_ code: T) where T: FixedWidthInteger {
        guard code > 0 && code <= FastlyStatus.allCases.last!.rawValue else {
            return nil
        }
        self = Self.allCases[Int(code)]
    }
}

public enum HttpVersion: UInt32 {
    case http0_9 = 0
    case http1_0
    case http1_1
    case h2
    case h3
}

public typealias HttpStatus = UInt16

public enum BodyWriteEnd: UInt32 {
    case back = 0
    case front
}

public typealias CacheOverrideTag = UInt32

public typealias BodyHandle = WasiHandle

public typealias RequestHandle = WasiHandle

public typealias ResponseHandle = WasiHandle

public typealias PendingRequestHandle = WasiHandle

public typealias EndpointHandle = WasiHandle

public typealias DictionaryHandle = WasiHandle

public typealias MultiValueCursor = UInt32

public typealias MultiValueCursorResult = Int64

extension CacheOverrideTag {
    public static let none: Self = 0x1
    public static let pass: Self = 0x2
    public static let ttl: Self = 0x4
    public static let staleWhileRevalidate: Self = 0x8
    public static let pci: Self = 0x10
}

public typealias HeaderCount = UInt32

public typealias IsDone = UInt32

public typealias DoneIndex = UInt32

public typealias ContentEncodings = UInt32

extension ContentEncodings {

    public static let gzip: Self = 1
}

public struct FastlyAbi {

    public static func initialize(version: UInt64) throws -> FastlyStatus {
        let result = try callRuntime {
            fastly_abi__init(version)
        }
        return FastlyStatus(rawValue: result)!
    }
}

public struct FastlyDictionary {
    private let handle: DictionaryHandle

    public init(name: String) throws {
        var handle: DictionaryHandle = 0
        _ = try callRuntime {
            name.withCString { namePointer in
                fastly_dictionary__open(UnsafeMutablePointer(mutating: namePointer), Int32(name.utf8.count), &handle)
            }
        }
        self.handle = handle
    }

    public func get(key: String) throws -> String {
        var resultMaxLength: Int32 = 128
        var resultLength: Int32 = 0
        var resultPointer = UnsafeMutablePointer<CChar>.allocate(capacity: Int(resultMaxLength))
        try key.withCString { keyPointer in
            while true {
                do {
                    try _ = callRuntime {
                        fastly_dictionary__get(
                            handle,
                            UnsafeMutablePointer(mutating: keyPointer),
                            Int32(key.utf8.count),
                            resultPointer,
                            resultMaxLength,
                            &resultLength
                        )
                    }
                    break
                } catch {
                    if let error = error as? FastlyError, error == .bufferLengthError {
                        resultMaxLength *= 2
                        resultPointer = UnsafeMutablePointer<CChar>.allocate(capacity: Int(resultMaxLength))
                    } else {
                        throw error
                    }
                }
            }
        }
        return String(cString: resultPointer)
    }
}

func callRuntime<T>(_ handler: () -> T) throws -> T where T: FixedWidthInteger {
    let result = handler()
    if let error = FastlyError(result) {
        throw error
    }
    return result
}
