//
//  IncomingRequest+Fanout.swift
//  
//
//  Created by Andrew Barba on 2/1/23.
//

import Foundation

public enum FanoutRequestError: Error, Sendable {
    case invalidSignature
}

extension IncomingRequest {

    public enum UpgradeWebsocketDestination {
        case proxy
        case fanout
    }

    public func isUpgradeWebsocketRequest() -> Bool {
        let connection = headers[.connection, default: ""].lowercased()
        let upgrade = headers[.upgrade, default: ""].lowercased()
        return connection.contains("upgrade") && upgrade.contains("websocket")
    }

    public func isFanoutRequest() -> Bool {
        return headers[.gripSig] != nil
    }

    public var connectionId: String? {
        return headers[.connectionId]
    }

    public func meta(_ key: String) -> String? {
        return headers["Meta-\(key)".lowercased()]
    }

    public func verifyFanoutRequest() throws {
        // TODO: Enable once we support ECDSA signature verification
        // guard let token = headers[.gripSig] else {
        //     throw FanoutRequestError.invalidSignature
        // }
        // let jwt = try JWT(token: token)
        // try jwt.verify(key: fanoutPublicKey, issuer: "fastly")
        fatalError("We do not support verifying ECDSA signatures at this time. Please use unsafe_verifyFanoutRequest for basic, non cryptographic verification of the signature.")
    }

    /// Important: this does not correctly verify the signature against Fastly's public key
    /// We cannot verify this signature until our underlying crypto library supports Elliptic curves
    public func unsafe_verifyFanoutRequest() throws {
        guard let token = headers[.gripSig] else {
            throw FanoutRequestError.invalidSignature
        }

        let jwt = try JWT(token: token)

        guard let typ = jwt.header["typ"] as? String, typ == "JWT" else {
            throw FanoutRequestError.invalidSignature
        }

        guard let alg = jwt.header["alg"] as? String, alg == "ES256" else {
            throw FanoutRequestError.invalidSignature
        }

        guard let iss = jwt["iss"].string, iss == "fastly" else {
            throw FanoutRequestError.invalidSignature
        }

        guard jwt.signature.count == 64 else {
            throw FanoutRequestError.invalidSignature
        }

        guard let expDate = jwt.expiresAt, Date() < expDate else {
            throw FanoutRequestError.invalidSignature
        }
    }

    public func upgradeWebsocket(to destination: UpgradeWebsocketDestination, hostname: String = "localhost") throws {
        switch destination {
        case .proxy:
            try request.redirectToWebsocketProxy(backend: hostname)
        case .fanout:
            try request.redirectToGripProxy(backend: hostname)
        }
    }

    public func fanoutMessage() async throws -> FanoutMessage {
        let text = try await body.text()
        return try FanoutMessage(text)
    }
}
