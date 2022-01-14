//
//  File.swift
//  
//
//  Created by Andrew Barba on 1/13/22.
//

import ComputeRuntime
import Foundation

public class OutgoingResponse {

    private var response: HttpResponse

    private var didSendStreamingBody = false

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
        try body.write(object, encoder: encoder)
        try sendStreamingBodyIfNeeded()
        return self
    }

    @discardableResult
    public func write(_ text: String) throws -> Self {
        try body.write(text)
        try sendStreamingBodyIfNeeded()
        return self
    }

    @discardableResult
    public func write(_ data: Data) throws -> Self {
        try body.write(data)
        try sendStreamingBodyIfNeeded()
        return self
    }

    @discardableResult
    public func write(_ bytes: [UInt8]) throws -> Self {
        try body.write(bytes)
        try sendStreamingBodyIfNeeded()
        return self
    }

    @discardableResult
    public func send<T>(_ object: T, encoder: JSONEncoder = .init()) throws -> Self where T: Encodable {
        try body.write(object, encoder: encoder)
        try response.send(body, streaming: false)
        return self
    }

    @discardableResult
    public func send(_ text: String) throws -> Self {
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

    @discardableResult
    public func cancel() throws -> Self {
        try response.close()
        return self
    }
}
