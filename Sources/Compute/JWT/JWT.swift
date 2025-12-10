//
//  JWT.swift
//
//
//  Created by Andrew Barba on 11/27/22.
//

public protocol JWTPayload: Sendable, Codable {
    var iat: TimeInterval? { get set }
    var exp: TimeInterval? { get set }
    var sub: String? { get set }
    var iss: String? { get set }
    var jti: String? { get set }
}

public enum JWTAlgorithm: String, Codable, Sendable {
    case hs256 = "HS256"
    case hs384 = "HS384"
    case hs512 = "HS512"
    case es256 = "ES256"
    case es384 = "ES384"
    case es512 = "ES512"
}

public struct JWTHeader: Sendable, Codable {
    public let alg: JWTAlgorithm
    public let typ: String
}

public struct EmptyJWTPayload: JWTPayload {
    public var iat: TimeInterval?
    public var exp: TimeInterval?
    public var sub: String?
    public var iss: String?
    public var jti: String?

    public init() {}
}

public struct JWT<Payload: JWTPayload>: Sendable, Codable {

    public let token: String

    public let algorithm: JWTAlgorithm

    public let header: JWTHeader

    public let payload: Payload

    public let signature: Data

    public func claim(name: String) -> Claim {
        return .init(value: payload)[name]
    }

    public subscript(key: String) -> Claim {
        return claim(name: key)
    }

    public init(token: String) throws {
        // Verify token parts
        let parts = token.components(separatedBy: ".")
        guard parts.count == 3 else {
            throw JWTError.invalidToken
        }

        // Parse header
        let header: JWTHeader = try decodeJWTPart(parts[0])

        // Parse payload
        let payload: Payload = try decodeJWTPart(parts[1])

        // Parse signature
        let signature = try base64UrlDecode(parts[2])

        self.header = header
        self.payload = payload
        self.signature = signature
        self.algorithm = header.alg
        self.token = token
    }

    public init(
        claims: Payload,
        secret: String,
        algorithm: JWTAlgorithm = .hs256,
        issuedAt: Date = .init(),
        expiresAt: Date? = nil,
        issuer: String? = nil,
        subject: String? = nil,
        identifier: String? = nil
    ) throws {
        let header = JWTHeader(alg: algorithm, typ: "JWT")

        var payload = claims

        payload.iat = issuedAt.timeIntervalSince1970.rounded(.down)

        if let expiresAt {
            payload.exp = expiresAt.timeIntervalSince1970.rounded(.up)
        }

        if let subject {
            payload.sub = subject
        }

        if let issuer {
            payload.iss = issuer
        }

        if let identifier {
            payload.jti = identifier
        }

        let _header = try encodeJWTPart(header)

        let _payload = try encodeJWTPart(payload)

        let input = "\(_header).\(_payload)"

        let signature = try hmacSignature(input, secret: secret, using: algorithm)

        let _signature = try base64UrlEncode(signature)

        self.header = header
        self.payload = payload
        self.signature = signature
        self.algorithm = algorithm
        self.token = "\(_header).\(_payload).\(_signature)"
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
        guard let expiresAt = self.expiresAt else {
            return false
        }
        return Date() > expiresAt
    }
}

extension JWT {

    @discardableResult
    public func verify(
        key: String,
        using algorithm: JWTAlgorithm? = nil,
        issuer: String? = nil,
        subject: String? = nil,
        expiration: Bool = true
    ) throws -> Self {
        // Build input
        let input = token.components(separatedBy: ".").prefix(2).joined(separator: ".")

        // Ensure the signatures match
        try verifySignature(
            input, signature: signature, key: key, using: algorithm ?? self.algorithm)

        // Ensure the jwt is not expired
        if expiration, self.expired == true {
            throw JWTError.expiredToken
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

private func decodeJWTPart<T: Decodable>(_ value: String) throws -> T {
    let bodyData = try base64UrlDecode(value)
    guard let json = try? JSONDecoder().decode(T.self, from: bodyData) else {
        throw JWTError.invalidJSON
    }
    return json
}

private func encodeJWTPart<T: Encodable>(_ value: T) throws -> String {
    let data = try JSONEncoder().encode(value)
    return try base64UrlEncode(data)
}

private func hmacSignature(_ input: String, secret: String, using algorithm: JWTAlgorithm) throws
    -> Data
{
    switch algorithm {
    case .hs256:
        return Crypto.Auth.code(for: input, secret: secret, using: .sha256)
    case .hs384:
        return Crypto.Auth.code(for: input, secret: secret, using: .sha384)
    case .hs512:
        return Crypto.Auth.code(for: input, secret: secret, using: .sha512)
    case .es256:
        return try Crypto.ECDSA.signature(for: input, secret: secret, using: .p256)
    case .es384:
        return try Crypto.ECDSA.signature(for: input, secret: secret, using: .p384)
    case .es512:
        return try Crypto.ECDSA.signature(for: input, secret: secret, using: .p521)
    }
}

private func verifySignature(
    _ input: String, signature: Data, key: String, using algorithm: JWTAlgorithm
) throws {
    let verified: Bool
    switch algorithm {
    case .es256:
        verified = try Crypto.ECDSA.verify(input, signature: signature, key: key, using: .p256)
    case .es384:
        verified = try Crypto.ECDSA.verify(input, signature: signature, key: key, using: .p384)
    case .es512:
        verified = try Crypto.ECDSA.verify(input, signature: signature, key: key, using: .p521)
    case .hs256:
        verified = Crypto.Auth.verify(input, signature: signature, secret: key, using: .sha256)
    case .hs384:
        verified = Crypto.Auth.verify(input, signature: signature, secret: key, using: .sha384)
    case .hs512:
        verified = Crypto.Auth.verify(input, signature: signature, secret: key, using: .sha512)
    }
    guard verified else {
        throw JWTError.invalidSignature
    }
}

private func base64UrlDecode(_ value: String) throws -> Data {
    var base64 =
        value
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")
    let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
    let requiredLength = 4 * (length / 4.0).rounded(.up)
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

private func base64UrlEncode(_ value: Data) throws -> String {
    return
        value
        .base64EncodedString()
        .trimmingCharacters(in: ["="])
        .replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_")
}
