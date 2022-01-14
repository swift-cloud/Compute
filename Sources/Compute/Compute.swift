//
//  SwiftCompute.swift
//
//
//  Created by Andrew Barba on 1/11/22.
//

public func onIncomingRequest(_ handler: @escaping (_ req: IncomingRequest, _ res: OutgoingResponse) async throws -> Void) async throws {
    do {
        let req = try IncomingRequest()
        let res = try OutgoingResponse()
        try await handler(req, res)
    } catch {
        print("req:error", error)
    }
}
