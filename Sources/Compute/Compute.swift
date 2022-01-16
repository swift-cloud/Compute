//
//  Compute.swift
//
//
//  Created by Andrew Barba on 1/11/22.
//

public func onIncomingRequest(_ handler: @escaping (_ req: IncomingRequest, _ res: OutgoingResponse) async throws -> Void) async {
    do {
        let req = try IncomingRequest()
        let res = try OutgoingResponse()
        do {
            try await handler(req, res)
        } catch {
            print("onIncomingRequest:error", error.localizedDescription)
            try res.status(500).send("Server error: \(error.localizedDescription)")
        }
    } catch {
        fatalError("Something went wrong.")
    }
}
