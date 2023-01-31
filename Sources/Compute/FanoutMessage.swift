//
//  FanoutMessage.swift
//  
//
//  Created by Andrew Barba on 1/31/23.
//

private let eol = "\r\n"

public struct FanoutMessage: Sendable {
    public enum Event: String, Sendable, Codable {
        case open = "OPEN"
        case text = "TEXT"
        case ping = "PING"
        case pong = "PONG"
        case close = "CLOSE"
        case disconnect = "DISCONNECT"
    }

    public let event: Event

    public let content: String

    public init(_ event: Event, content: String = "") {
        self.event = event
        self.content = content
    }

    public init<T: Encodable>(_ event: Event, value: T, encoder: JSONEncoder = .init()) throws {
        self.event = event
        self.content = try String(data: encoder.encode(value), encoding: .utf8)!
    }

    public func encoded() -> String {
        switch content.isEmpty {
        case true:
            return "\(event.rawValue)\(eol)"
        case false:
            let size = String(content.count, radix: 16, uppercase: true)
            return "\(event.rawValue) \(size)\(eol)\(content)\(eol)"
        }
    }
}

extension FanoutMessage {

    public static var open: Self {
        return .init(.open)
    }

    public static func subscribe(to channel: String) -> Self {
        let content = #"c:{"type": "subscribe", "channel": "\#(channel)"}"#
        return .init(.text, content: content)
    }
}
