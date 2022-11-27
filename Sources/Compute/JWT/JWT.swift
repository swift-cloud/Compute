//
//  JWT.swift
//  
//
//  Created by Andrew Barba on 11/27/22.
//

import CryptoSwift
import Foundation

public enum JWTError: Error {
    case invalidToken
    case invalidBase64URL
    case invalidJSON
    case invalidSignature
    case invalidIssuer
    case invalidSubject
    case expired
}

public struct JWT {

    public let header: [String: Any]

    public let payload: [String: Any]

    private let _header: String

    private let _payload: String

    private let _signature: String

    public func claim(name: String) -> Claim {
        return .init(value: payload[name])
    }

    public subscript(key: String) -> Claim {
        return claim(name: key)
    }

    public init(_ token: String) throws {
        let parts = token.components(separatedBy: ".")
        guard parts.count == 3 else {
            throw JWTError.invalidToken
        }
        self._header = parts[0]
        self._payload = parts[1]
        self._signature = parts[2]
        self.header = try decodeJWTPart(parts[0])
        self.payload = try decodeJWTPart(parts[1])
    }
}

extension JWT {

    public var expiresAt: Date? {
        claim(name: "exp").date
    }

    public var issuer: String? {
        claim(name: "iss").string
    }

    public var subject: String? {
        claim(name: "sub").string
    }

    public var audience: [String]? {
        claim(name: "aud").array
    }

    public var issuedAt: Date? {
        claim(name: "iat").date
    }

    public var notBefore: Date? {
        claim(name: "nbf").date
    }

    public var identifier: String? {
        claim(name: "jti").string
    }

    public var expired: Bool {
        guard let date = self.expiresAt else {
            return false
        }
        return Date() < date
    }
}

extension JWT {

    @discardableResult
    public func verify(
        secret: String,
        algorithm: HMAC.Variant = .sha2(.sha256),
        issuer: String? = nil,
        subject: String? = nil
    ) throws -> Self {
        // Build input
        let input = "\(_header).\(_payload)"

        // Build hex signature
        let signature = try base64UrlDecode(_signature).toHexString()

        // Compute signature based on secret
        let computedSignature = try HMAC(key: secret.bytes, variant: algorithm)
            .authenticate(input.bytes)
            .toHexString()

        // Ensure the signatures match
        guard signature == computedSignature else {
            throw JWTError.invalidSignature
        }

        // Ensure the jwt is not expired
        guard expired == false else {
            throw JWTError.expired
        }

        // Check for a matching issuer
        if let issuer, issuer != self.issuer {
            throw JWTError.invalidIssuer
        }

        // Check for a matching subject
        if let subject, subject != self.subject {
            throw JWTError.invalidSubject
        }

        return self
    }
}

extension JWT {
    public struct Claim {

        /// Raw claim value.
        let value: Any?

        /// Original claim value.
        public var rawValue: Any? {
            return self.value
        }

        /// Value of the claim as `String`.
        public var string: String? {
            return self.value as? String
        }

        /// Value of the claim as `Bool`.
        public var boolean: Bool? {
            return self.value as? Bool
        }

        /// Value of the claim as `Double`.
        public var double: Double? {
            var double: Double?
            if let string = self.string {
                double = Double(string)
            } else if self.boolean == nil {
                double = self.value as? Double
            }
            return double
        }

        /// Value of the claim as `Int`.
        public var integer: Int? {
            var integer: Int?
            if let string = self.string {
                integer = Int(string)
            } else if let double = self.double {
                integer = Int(double)
            } else if self.boolean == nil {
                integer = self.value as? Int
            }
            return integer
        }

        /// Value of the claim as `Date`.
        public var date: Date? {
            guard let timestamp: TimeInterval = self.double else { return nil }
            return Date(timeIntervalSince1970: timestamp)
        }

        /// Value of the claim as `[String]`.
        public var array: [String]? {
            if let array = self.value as? [String] {
                return array
            }
            if let value = self.string {
                return [value]
            }
            return nil
        }

        /// Value of the claim as `[String: Any]`.
        public var dictionary: [String: Any]? {
            if let dict = self.value as? [String: Any] {
                return dict
            }
            return nil
        }
    }
}

private func decodeJWTPart(_ value: String) throws -> [String: Any] {
    let bodyData = try base64UrlDecode(value)
    guard let json = try JSONSerialization.jsonObject(with: bodyData, options: []) as? [String: Any] else {
        throw JWTError.invalidJSON
    }
    return json
}

private func base64UrlDecode(_ value: String) throws -> Data {
    var base64 = value
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")
    let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
    let requiredLength = 4 * ceil(length / 4.0)
    let paddingLength = requiredLength - length
    if paddingLength > 0 {
        let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
        base64 += padding
    }
    guard let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) else {
        throw JWTError.invalidBase64URL
    }
    return data
}
