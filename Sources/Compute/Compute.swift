//
//  Compute.swift
//
//
//  Created by Andrew Barba on 1/11/22.
//

public func onIncomingRequest(_ handler: @escaping (_ req: IncomingRequest, _ res: OutgoingResponse) async throws -> Void) async {
    do {
        print("Creating incoming request...")
        let req = try IncomingRequest()
        print("Created incoming request.")
        print("Creating outgoing response...")
        let res = try OutgoingResponse()
        print("Created outgoing response.")
        do {
            print("Running handler...")
            try await handler(req, res)
            print("Ran handler.")
        } catch {
            print("onIncomingRequest:error", error.localizedDescription)
            try await res.status(500).send("Server error: \(error.localizedDescription)")
        }
    } catch {
        print("Fatal Error:", error.localizedDescription)
    }
}
