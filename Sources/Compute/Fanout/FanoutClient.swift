//
//  FanoutClient.swift
//
//
//  Created by Andrew Barba on 2/1/23.
//

import Foundation

public struct FanoutClient: Sendable {

    public let service: String

    public let hostname: String

    private let token: String

    private var publishEndpoint: String {
        "https://\(hostname)/service/\(service)/publish/"
    }

    public init(
        service: String = Fastly.Environment.serviceId, token: String,
        hostname: String = "api.fastly.com"
    ) {
        self.service = service
        self.token = token
        self.hostname = hostname
    }

    @discardableResult
    public func publish(_ message: PublishMessage) async throws -> FetchResponse {
        return try await fetch(
            publishEndpoint,
            .options(
                method: .post,
                body: .json(message),
                headers: ["Fastly-Key": token]
            ))
    }

    @discardableResult
    public func publish(_ content: String, to channel: String) async throws -> FetchResponse {
        let message = PublishMessage(items: [
            .init(channel: channel, formats: .init(wsMessage: .init(content: content)))
        ])
        return try await publish(message)
    }

    @discardableResult
    public func publish<T: Encodable>(
        _ value: T, encoder: JSONEncoder = .init(), to channel: String
    ) async throws -> FetchResponse {
        let content = try encoder.encode(value)
        return try await publish(content, to: channel)
    }

    @discardableResult
    public func publish(_ json: Any, to channel: String) async throws -> FetchResponse {
        let data = try JSONSerialization.data(withJSONObject: json)
        let content = String(data: data, encoding: .utf8)
        return try await publish(content, to: channel)
    }

    @discardableResult
    public func publish(_ jsonObject: [String: Any], to channel: String) async throws
        -> FetchResponse
    {
        let data = try JSONSerialization.data(withJSONObject: jsonObject)
        let content = String(data: data, encoding: .utf8)
        return try await publish(content, to: channel)
    }

    @discardableResult
    public func publish(_ jsonArray: [Any], to channel: String) async throws -> FetchResponse {
        let data = try JSONSerialization.data(withJSONObject: jsonArray)
        let content = String(data: data, encoding: .utf8)
        return try await publish(content, to: channel)
    }
}

extension FanoutClient {
    public struct PublishMessage: Codable, Sendable {
        public let items: [PublishMessageItem]

        public init(items: [PublishMessageItem]) {
            self.items = items
        }
    }

    public struct PublishMessageItem: Codable, Sendable {
        public let channel: String
        public let formats: PublishMessageItemFormats

        public init(channel: String, formats: PublishMessageItemFormats) {
            self.channel = channel
            self.formats = formats
        }
    }

    public struct PublishMessageItemFormats: Codable, Sendable {
        enum CodingKeys: String, CodingKey {
            case wsMessage = "ws-message"
        }
        public let wsMessage: PublishMessageItemContent

        public init(wsMessage: PublishMessageItemContent) {
            self.wsMessage = wsMessage
        }
    }

    public struct PublishMessageItemContent: Codable, Sendable {
        public let content: String

        public init(content: String) {
            self.content = content
        }
    }
}
