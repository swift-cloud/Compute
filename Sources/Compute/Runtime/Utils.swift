//
//  Utils.swift
//  
//
//  Created by Andrew Barba on 1/12/22.
//

import CoreFoundation
import Foundation

internal func wasi(_ handler: @autoclosure () -> UInt32) throws {
    let result = handler()
    if let status = WasiStatus(rawValue: result), status != .ok {
        throw status
    }
}

internal struct Utils {
    
    internal static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
