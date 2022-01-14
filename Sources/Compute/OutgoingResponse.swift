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

    public var status: HttpStatus {
        response.status ?? 200
    }

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
    public func status(_ newValue: HttpStatus) -> Self {
        response.status = status
        return self
    }

    public func write<T>(_ object: T, encoder: JSONEncoder = .init()) throws where T: Encodable {
        try body.write(object, encoder: encoder)
        try sendStreamingBodyIfNeeded()
    }

    public func write(_ text: String) throws {
        try body.write(text)
        try sendStreamingBodyIfNeeded()
    }

    public func write(_ data: Data) throws {
        try body.write(data)
        try sendStreamingBodyIfNeeded()
    }

    public func write(_ bytes: [UInt8]) throws {
        try body.write(bytes)
        try sendStreamingBodyIfNeeded()
    }

    public func send<T>(_ object: T, encoder: JSONEncoder = .init()) throws where T: Encodable {
        try body.write(object, encoder: encoder)
        try response.send(body, streaming: false)
    }

    public func send(_ text: String) throws {
        try body.write(text)
        try response.send(body, streaming: false)
    }

    public func send(_ data: Data) throws {
        try body.write(data)
        try response.send(body, streaming: false)
    }

    public func send(_ bytes: [UInt8]) throws {
        try body.write(bytes)
        try response.send(body, streaming: false)
    }

    public func end() throws {
        try body.close()
    }

    public func cancel() throws {
        try response.close()
    }
}
