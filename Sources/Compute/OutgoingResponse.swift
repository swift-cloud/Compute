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

    internal private(set) var didSendStreamingBody = false

    public private(set) var headers: Headers<HttpResponse>

    public private(set) var body: HttpBody

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
        self.body = try HttpBody()
        self.headers = Headers(response)
    }

    private func sendStreamingBodyIfNeeded() throws {
        defer { didSendStreamingBody = true }
        guard didSendStreamingBody == false else { return }
        try response.send(body, streaming: true)
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
    public func write<T>(_ object: T, encoder: JSONEncoder = .init()) throws -> Self where T: Encodable {
        try sendStreamingBodyIfNeeded()
        try body.write(object, encoder: encoder)
        return self
    }

    @discardableResult
    public func write(_ json: Any) throws -> Self {
        try sendStreamingBodyIfNeeded()
        try body.write(json)
        return self
    }

    @discardableResult
    public func write(_ text: String) throws -> Self {
        try sendStreamingBodyIfNeeded()
        try body.write(text)
        return self
    }

    @discardableResult
    public func write(_ data: Data) throws -> Self {
        try sendStreamingBodyIfNeeded()
        try body.write(data)
        return self
    }

    @discardableResult
    public func write(_ bytes: [UInt8]) throws -> Self {
        try sendStreamingBodyIfNeeded()
        try body.write(bytes)
        return self
    }

    @discardableResult
    public func write(_ source: inout HttpBody, end: Bool = true) throws -> Self {
        try sendStreamingBodyIfNeeded()
        try source.pipeTo(&body, end: end)
        return self
    }

    @discardableResult
    public func append(_ source: HttpBody) throws -> Self {
        try sendStreamingBodyIfNeeded()
        try body.append(source)
        return self
    }

    @discardableResult
    public func send<T>(_ object: T, encoder: JSONEncoder = .init()) throws -> Self where T: Encodable {
        try defaultContentType("application/json")
        try body.write(object, encoder: encoder)
        try response.send(body, streaming: false)
        return self
    }

    @discardableResult
    public func send(_ json: Any) throws -> Self {
        try defaultContentType("application/json")
        try body.write(json)
        try response.send(body, streaming: false)
        return self
    }

    @discardableResult
    public func send(_ text: String, html: Bool = false) throws -> Self {
        try defaultContentType(html ? "text/html" : "text/plain")
        try body.write(text)
        try response.send(body, streaming: false)
        return self
    }

    @discardableResult
    public func send(_ data: Data) throws -> Self {
        try body.write(data)
        try response.send(body, streaming: false)
        return self
    }

    @discardableResult
    public func send(_ bytes: [UInt8]) throws -> Self {
        try body.write(bytes)
        try response.send(body, streaming: false)
        return self
    }

    @discardableResult
    public func end() throws -> Self {
        try body.close()
        return self
    }

    public func redirect(_ location: String, permanent: Bool = false) throws {
        status = permanent ? 308 : 307
        headers["location"] = location
        try send("Redirecting to \(location)")
    }

    @discardableResult
    public func cancel() throws -> Self {
        try response.close()
        return self
    }
}
