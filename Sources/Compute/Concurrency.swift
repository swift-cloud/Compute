//
//  Concurrency.swift
//
//
//  Created by Andrew Barba on 11/27/22.
//

extension Data: @unchecked Sendable {}

extension URL: @unchecked Sendable {}

#if !arch(wasm32)
    extension HTTPURLResponse: @unchecked Sendable {}
#endif

extension Task where Success == Never, Failure == Never {

    internal static func nextTick() async throws {
        try await sleep(nanoseconds: 0)
    }
}
