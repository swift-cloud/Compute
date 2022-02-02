//
//  Stubs.swift
//  
//
//  Created by Andrew Barba on 2/2/22.
//

import ComputeRuntime

/// Note:
/// Define all runtime functions stub which are imported from Compute environment.
/// SwiftPM doesn't support WebAssembly target yet, so we need to define them to
/// avoid link failure.
/// When running with Compute runtime library, they are ignored completely.
#if !arch(wasm32)

func fastly_abi__init(_ abi_version: UInt64) -> Int32 { fatalError() }

#endif
