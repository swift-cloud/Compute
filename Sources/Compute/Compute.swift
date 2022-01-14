//
//  SwiftCompute.swift
//
//
//  Created by Andrew Barba on 1/11/22.
//

@available(macOS 10.15, *)
public func onIncomingRequest(_ handler: @escaping (_ req: IncomingRequest, _ res: OutgoingResponse) throws -> Void) {
//    Task {
        do {
            let req = try IncomingRequest()
            let res = try OutgoingResponse()
            try handler(req, res)
        } catch {
            print("req:error", error)
        }
//    }
}
