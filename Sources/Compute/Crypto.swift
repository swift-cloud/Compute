//
//  Crypto.swift
//  
//
//  Created by Andrew Barba on 2/8/23.
//

import Crypto

public enum Crypto {}

extension Crypto {

    public static func hash<T>(_ input: String, using hash: T.Type) -> T.Digest where T: HashFunction {
        return T.hash(data: Data(input.utf8))
    }

    public static func hash<T>(_ input: [UInt8], using hash: T.Type) -> T.Digest where T: HashFunction {
        return T.hash(data: Data(input))
    }

    public static func hash<T>(_ input: Data, using hash: T.Type) -> T.Digest where T: HashFunction {
        return T.hash(data: input)
    }

    public static func sha256(_ input: String) -> SHA256.Digest {
        return hash(input, using: SHA256.self)
    }

    public static func sha256(_ input: [UInt8]) -> SHA256.Digest {
        return hash(input, using: SHA256.self)
    }

    public static func sha256(_ input: Data) -> SHA256.Digest {
        return hash(input, using: SHA256.self)
    }

    public static func sha384(_ input: String) -> SHA384.Digest {
        return hash(input, using: SHA384.self)
    }

    public static func sha384(_ input: [UInt8]) -> SHA384.Digest {
        return hash(input, using: SHA384.self)
    }

    public static func sha384(_ input: Data) -> SHA384.Digest {
        return hash(input, using: SHA384.self)
    }

    public static func sha512(_ input: String) -> SHA512.Digest {
        return hash(input, using: SHA512.self)
    }

    public static func sha512(_ input: [UInt8]) -> SHA512.Digest {
        return hash(input, using: SHA512.self)
    }

    public static func sha512(_ input: Data) -> SHA512.Digest {
        return hash(input, using: SHA512.self)
    }
}

extension DataProtocol {

    public var bytes: [UInt8] {
        return .init(self)
    }

    public func toHexString() -> String {
        return reduce("") {$0 + String(format: "%02x", $1)}
    }
}

extension Digest {

    public func toHexString() -> String {
        return reduce("") {$0 + String(format: "%02x", $1)}
    }
}

extension Array where Element == UInt8 {
    public func toHexString() -> String {
        return reduce("") {$0 + String(format: "%02x", $1)}
    }
}
