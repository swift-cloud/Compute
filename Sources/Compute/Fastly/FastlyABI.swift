//
//  ABI.swift
//  
//
//  Created by Andrew Barba on 1/12/22.
//

import FastlyWorld

extension Fastly {
    public struct ABI: Sendable {

        public static let currentABIVersion: UInt64 = 1

        public static func initialize(version: UInt64 = currentABIVersion) throws {
            try fastlyWorld { err in
                fastly_abi_init(version, &err)
            }
        }

        private init() {}
    }
}
