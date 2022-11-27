//
//  Concurrency.swift
//  
//
//  Created by Andrew Barba on 11/27/22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Data: @unchecked Sendable {}

extension URL: @unchecked Sendable {}

#if !arch(wasm32)
extension HTTPURLResponse: @unchecked Sendable {}
#endif
