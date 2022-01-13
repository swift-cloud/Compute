//
//  ABI.swift
//  
//
//  Created by Andrew Barba on 1/12/22.
//

import ComputeRuntime

public struct ABI {

    public static func initialize(version: UInt64) throws -> WasiStatus {
        try wasi(fastly_abi__init(version))
        return .ok
    }
}
