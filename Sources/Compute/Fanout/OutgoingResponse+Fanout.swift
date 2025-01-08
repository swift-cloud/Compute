//
//  OutgoingResponse+Fanout.swift
//
//
//  Created by Andrew Barba on 2/2/23.
//

import Foundation

extension OutgoingResponse {

    public func meta(_ key: String, _ value: String?) -> Self {
        return header("Set-Meta-\(key)".lowercased(), value)
    }

    public func send(fanout messages: FanoutMessage...) async throws {
        try await send(fanout: messages)
    }

    public func send(fanout messages: [FanoutMessage]) async throws {
        headers[.contentType] = "application/websocket-events"
        headers[.secWebSocketExtensions] = "grip; message-prefix=\"\""
        let data = messages.map { $0.encoded() }.joined(separator: "").data(using: .utf8) ?? .init()
        try await send(data)
    }
}
