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
        guard let token = headers[.gripSig] else {
            throw FanoutRequestError.invalidSignature
        }
        let jwt = try JWT(token: token)
        try jwt.verify(key: fanoutPublicKey)
    }

    public func upgradeWebsocket(
        to destination: UpgradeWebsocketDestination, hostname: String = "localhost"
    ) throws {
        switch destination {
        case .proxy:
            try request.redirectToWebsocketProxy(backend: hostname)
        case .fanout:
            try request.redirectToGripProxy(backend: hostname)
        }
    }

    public func fanoutMessage(verifySignature: Bool = true) async throws -> FanoutMessage {
        if verifySignature {
            try verifyFanoutRequest()
        }
        let text = try await body.text()
        return try FanoutMessage(text)
    }
}
