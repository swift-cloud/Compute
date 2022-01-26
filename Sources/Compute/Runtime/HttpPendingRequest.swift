//
//  HttpPendingRequest.swift
//  
//
//  Created by Andrew Barba on 1/14/22.
//

import ComputeRuntime

public struct HttpPendingRequest: Sendable {

    internal let handle: PendingRequestHandle

    public let request: HttpRequest

    internal init(_ handle: PendingRequestHandle, request: HttpRequest) {
        self.handle = handle
        self.request = request
    }

    internal func wait() throws -> (response: HttpResponse, body: HttpBody) {
        var responseHandle: ResponseHandle = 0
        var bodyHandle: BodyHandle = 0
        try wasi(fastly_http_req__pending_req_wait(handle, &responseHandle, &bodyHandle))
        return (.init(responseHandle), .init(bodyHandle))
    }

    internal func poll() throws -> (response: HttpResponse, body: HttpBody)? {
        var isDone: UInt32 = 0
        var responseHandle: ResponseHandle = 0
        var bodyHandle: BodyHandle = 0
        try wasi(fastly_http_req__pending_req_poll(handle, &isDone, &responseHandle, &bodyHandle))
        guard isDone > 0 else {
            return nil
        }
        return (.init(responseHandle), .init(bodyHandle))
    }

    internal static func select(_ requests: [HttpPendingRequest]) throws -> (index: Int, response: HttpResponse, body: HttpBody) {
        var handles = requests.map(\.handle)
        var doneIndex: UInt32 = 0
        var responseHandle: ResponseHandle = 0
        var bodyHandle: BodyHandle = 0
        try wasi(fastly_http_req__pending_req_select(&handles, handles.count, &doneIndex, &responseHandle, &bodyHandle))
        return (.init(doneIndex), .init(responseHandle), .init(bodyHandle))
    }
}
