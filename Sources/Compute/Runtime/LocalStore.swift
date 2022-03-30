//
//  LocalStore.swift
//  
//
//  Created by Andrew Barba on 3/30/22.
//

import ComputeRuntime

public func LocalStore() throws -> GlobalStore {
    try GlobalStore(name: "__fastly-local-store")
}
