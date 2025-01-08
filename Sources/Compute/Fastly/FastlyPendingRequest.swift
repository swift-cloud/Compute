//
//  PendingRequest.swift
//
//
//  Created by Andrew Barba on 1/14/22.
//

import ComputeRuntime

extension Fastly {
    public struct PendingRequest: Sendable {

        internal let handle: WasiHandle

        public let request: Request

        internal init(_ handle: WasiHandle, request: Request) {
            self.handle = handle
            self.request = request
        }

        internal func wait() throws -> (response: Response, body: Body) {
            var responseHandle: WasiHandle = 0
            var bodyHandle: WasiHandle = 0
            try wasi(fastly_http_req__pending_req_wait(handle, &responseHandle, &bodyHandle))
            return (.init(responseHandle), .init(bodyHandle))
        }

        internal func poll() throws -> (response: Response, body: Body)? {
            var isDone: UInt32 = 0
            var responseHandle: WasiHandle = 0
            var bodyHandle: WasiHandle = 0
            try wasi(
                fastly_http_req__pending_req_poll(handle, &isDone, &responseHandle, &bodyHandle))
            guard isDone > 0 else {
                return nil
            }
            return (.init(responseHandle), .init(bodyHandle))
        }

        internal static func select(_ requests: [PendingRequest]) throws -> (
            index: Int, response: Response, body: Body
        ) {
            var handles = requests.map(\.handle)
            var doneIndex: UInt32 = 0
            var responseHandle: WasiHandle = 0
            var bodyHandle: WasiHandle = 0
            try wasi(
                fastly_http_req__pending_req_select(
                    &handles, handles.count, &doneIndex, &responseHandle, &bodyHandle))
            return (.init(doneIndex), .init(responseHandle), .init(bodyHandle))
        }
    }
}
