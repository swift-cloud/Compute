//
//  Utils.swift
//  
//
//  Created by Andrew Barba on 1/12/22.
//

internal func wasi(_ handler: @autoclosure () -> UInt32) throws {
    let result = handler()
    if let status = WasiStatus(rawValue: result), status != .ok {
        throw status
    }
}
