//
//  OutgoingResponse.swift
//  
//
//  Created by Andrew Barba on 1/13/22.
//

import ComputeRuntime
import Foundation

public class OutgoingResponse {

    internal private(set) var response: HttpResponse

    internal private(set) var didSend = false

    internal let body: WritableBody

    public private(set) var headers: Headers<HttpResponse>

    public var status: HttpStatus {
        get {
            let value = try? response.getStatus()
            return value ?? 200
        }
        set {
            try? response.setStatus(newValue)
        }
    }

    public var contentType: String? {
        get {
            return headers["conent-type"]
        }
        set {
            headers["content-type"] = newValue
        }
    }

    internal init() throws {
        let response = try HttpResponse()
        self.response = response
        self.body = WritableBody(try HttpBody())
        self.headers = Headers(response)
    }

    @discardableResult
    private func defaultContentType(_ value: String) throws -> Self {
        if contentType == nil {
            contentType = value
        }
        return self
    }

    @discardableResult
    public func contentType(_ value: String) -> Self {
        contentType = value
        return self
    }

    @discardableResult
    public func status(_ newValue: HttpStatus) -> Self {
        status = newValue
        return self
    }

    @discardableResult
    public func header(_ name: String, _ value: String?) -> Self {
        headers[name] = value
        return self
    }

    @discardableResult
    public func write<T>(_ object: T, encoder: JSONEncoder = .init()) async throws -> Self where T: Encodable {
        try await send(streaming: true)
        try await body.write(object, encoder: encoder)
        return self
    }

    @discardableResult
    public func write(_ jsonObject: [String: Any]) async throws -> Self {
        try await send(streaming: true)
        try await body.write(jsonObject)
        return self
    }

    @discardableResult
    public func write(_ jsonArray: [Any]) async throws -> Self {
        try await send(streaming: true)
        try await body.write(jsonArray)
        return self
    }

    @discardableResult
    public func write(_ text: String) async throws -> Self {
        try await send(streaming: true)
        try await body.write(text)
        return self
    }

    @discardableResult
    public func write(_ data: Data) async throws -> Self {
        try await send(streaming: true)
        try await body.write(data)
        return self
    }

    @discardableResult
    public func write(_ bytes: [UInt8]) async throws -> Self {
        try await send(streaming: true)
        try await body.write(bytes)
        return self
    }

    @discardableResult
    public func pipeFrom(_ source: ReadableBody) async throws -> Self {
        try await send(streaming: true)
        try await body.pipeFrom(source, preventClose: true)
        return self
    }

    @discardableResult
    public func append(_ sources: ReadableBody...) async throws -> Self {
        try await send(streaming: true)
        for source in sources {
            try await body.append(source)
        }
        return self
    }

    @discardableResult
    public func append(_ sources: [ReadableBody]) async throws -> Self {
        try await send(streaming: true)
        for source in sources {
            try await body.append(source)
        }
        return self
    }

    public func send<T>(_ object: T, encoder: JSONEncoder = .init()) async throws where T: Encodable {
        try defaultContentType("application/json")
        try await body.write(object, encoder: encoder)
        try await send()
    }

    public func send(_ jsonObject: [String: Any]) async throws {
        try defaultContentType("application/json")
        try await body.write(jsonObject)
        try await send()
    }

    public func send(_ jsonArray: [Any]) async throws {
        try defaultContentType("application/json")
        try await body.write(jsonArray)
        try await send()
    }

    public func send(_ text: String, html: Bool = false) async throws {
        try defaultContentType(html ? "text/html" : "text/plain")
        let data = text.data(using: .utf8) ?? .init()
        try await send(data)
    }

    public func send(_ data: Data) async throws {
        let bytes: [UInt8] = .init(data)
        try await send(bytes)
    }

    public func send(_ bytes: [UInt8]) async throws {
        try await body.write(bytes)
        try await send()
    }

    public func send(streaming: Bool = false) async throws {
        guard didSend == false else { return }
        didSend = true
        try await response.send(body.body, streaming: streaming)
    }

    public func end() async throws {
        try await body.close()
    }

    public func redirect(_ location: String, permanent: Bool = false) async throws {
        status = permanent ? 308 : 307
        headers["location"] = location
        try await send("Redirecting to \(location)")
    }

    public func cancel() throws {
        try response.close()
    }
}
