//
//  Body.swift
//  
//
//  Created by Andrew Barba on 1/13/22.
//

import FastlyWorld

extension Fastly {
    public struct Body: Sendable {

        public private(set) var used: Bool = false

        internal let handle: WasiHandle

        internal init(_ handle: WasiHandle) {
            self.handle = handle
        }

        internal init() throws {
            var handle: WasiHandle = 0
            try fastlyWorld { err in
                fastly_http_body_new(&handle, &err)
            }
            self.handle = handle
        }

        public mutating func append(_ source: Body) throws {
            try fastlyWorld { err in
                fastly_http_body_append(handle, source.handle, &err)
            }
            used = true
        }

        public mutating func close() throws {
            try fastlyWorld { err in
                fastly_http_body_close(handle, &err)
            }
        }

        @discardableResult
        public mutating func write(_ bytes: [UInt8], location: BodyWriteEnd = .back) throws -> Int {
            defer { used = true }
            var position = 0
            while position < bytes.count {
                try bytes[position..<bytes.count].withUnsafeBufferPointer { buffer in
                    var list_t = buffer.fastly_world_t
                    var written: UInt32 = 0
                    try fastlyWorld { err in
                        fastly_http_body_write(handle, &list_t, location.rawValue, &written, &err)
                    }
                    position += .init(written)
                }
            }
            return position
        }

        public mutating func scan(highWaterMark: Int = highWaterMark) throws -> [UInt8] {
            defer { used = true }
            return try Array<UInt8>(unsafeUninitializedCapacity: highWaterMark) { buffer, written in
                var list_t = buffer.fastly_world_t
                try fastlyWorld { err in
                    fastly_http_body_read(handle, .init(highWaterMark), &list_t, &err)
                }
                written = list_t.len
            }
        }

        public mutating func read(highWaterMark: Int = highWaterMark, onChunk: ([UInt8]) throws -> BodyScanContinuation) throws {
            while true {
                // Read chunk based on appropriate offset
                let chunk = try scan(highWaterMark: highWaterMark)

                // Make sure we read new bytes, else break
                guard chunk.count > 0 else {
                    return
                }

                // Trigger callback
                guard try onChunk(chunk) == .continue else {
                    return
                }
            }
        }
    }
}
