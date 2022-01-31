//
//  Compute.swift
//
//
//  Created by Andrew Barba on 1/11/22.
//

public func onIncomingRequest(_ handler: @escaping (_ req: IncomingRequest, _ res: OutgoingResponse) async throws -> Void) async throws {
    let req = try IncomingRequest()
    let res = try OutgoingResponse()
    do {
        try await handler(req, res)
    } catch {
        print("onIncomingRequest:error", error.localizedDescription)
        try await res.status(500).send("Server error: \(error.localizedDescription)")
    }
}
