//
//  ABI.swift
//  
//
//  Created by Andrew Barba on 1/12/22.
//

import ComputeRuntime

public struct ABI {

    public static let currentABIVersion = 1

    @discardableResult
    public static func initialize(version: Int = currentABIVersion) throws -> WasiStatus {
        try wasi(fastly_abi__init(UInt64(version)))
        return .ok
    }

    private init() {}
}
