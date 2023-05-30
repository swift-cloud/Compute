//
//  PendingRequest.swift
//  
//
//  Created by Andrew Barba on 1/14/22.
//

import FastlyWorld

extension Fastly {
    public struct PendingRequest: Sendable {

        internal let handle: WasiHandle

        public let request: Request

        internal init(_ handle: WasiHandle, request: Request) {
            self.handle = handle
            self.request = request
        }

        internal func wait() throws -> (response: Response, body: Body) {
            var response_t = fastly_response_t()
            try fastlyWorld { err in
                fastly_http_req_pending_req_wait(handle, &response_t, &err)
            }
            return (.init(response_t.f0), .init(response_t.f1))
        }

        internal func poll() throws -> (response: Response, body: Body)? {
            var response_t = fastly_world_option_response_t()
            try fastlyWorld { err in
                fastly_http_req_pending_req_poll(handle, &response_t, &err)
            }
            guard response_t.is_some else {
                return nil
            }
            return (.init(response_t.val.f0), .init(response_t.val.f1))
        }

        internal static func select(_ requests: [PendingRequest]) throws -> (index: Int, response: Response, body: Body) {
            var handles_t = requests.map(\.handle).fastly_world_t
            var tuple_t = fastly_world_tuple2_u32_response_t()
            try fastlyWorld { err in
                fastly_http_req_pending_req_select(&handles_t, &tuple_t, &err)
            }
            return (.init(tuple_t.f0), .init(tuple_t.f1.f0), .init(tuple_t.f1.f1))
        }
    }
}
