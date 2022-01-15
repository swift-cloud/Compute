//
//  OutgoingResponse.swift
//  
//
//  Created by Andrew Barba on 1/13/22.
//

import ComputeRuntime
import Foundation

public class OutgoingResponse {

    internal let response: HttpResponse

    internal private(set) var didSendStreamingBody = false

    public let body: HttpBody

    internal init() throws {
        try response = HttpResponse()
        try body = HttpBody()
    }

    private func sendStreamingBodyIfNeeded() throws {
        defer { didSendStreamingBody = true }
        guard didSendStreamingBody == false else { return }
        try response.send(body, streaming: true)
    }

    @discardableResult
    private func defaultContentType(_ value: String) throws -> Self {
        if try header("content-type") == nil {
            try contentType(value)
        }
        return self
    }

    public func header(_ name: String) throws -> String? {
        return try response.getHeader(name)
    }

    @discardableResult
    public func header(_ name: String, _ value: String?) throws -> Self {
        if let value = value {
            try response.insertHeader(name, value)
        } else if try response.getHeader(name) != nil {
            try response.removeHeader(name)
        }
        return self
    }

    public func contentType() throws -> String? {
        return try header("content-type")
    }

    @discardableResult
    public func contentType(_ value: String) throws -> Self {
        return try header("content-type", value)
    }

    public func status() throws -> HttpStatus {
        return try response.status()
    }

    @discardableResult
    public func status(_ newValue: HttpStatus) throws -> Self {
        try response.status(newValue)
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
    public func write(_ source: HttpBody, end: Bool = true) throws -> Self {
        try sendStreamingBodyIfNeeded()
        try source.pipeTo(body, end: end)
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
        try status(permanent ? 308 : 307)
        try header("location", location)
        try send("Redirecting to \(location)")
    }

    @discardableResult
    public func cancel() throws -> Self {
        try response.close()
        return self
    }
}
