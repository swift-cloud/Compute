//
//  File.swift
//  
//
//  Created by Andrew Barba on 1/13/22.
//

import ComputeRuntime

public class OutgoingResponse {

    private var response: HttpResponse

    public let body: HttpBody

    public var status: HttpStatus {
        response.status ?? 200
    }

    internal init() throws {
        try response = HttpResponse()
        try body = HttpBody()
    }

    @discardableResult
    public func status(_ newValue: HttpStatus) -> Self {
        response.status = status
        return self
    }

    public func send(streaming: Bool = false) throws {
        try response.send(body, streaming: streaming)
    }

    public func end() throws {
        try body.close()
    }

    public func close() throws {
        try response.close()
    }
}
