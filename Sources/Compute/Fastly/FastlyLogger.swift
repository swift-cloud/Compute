//
//  Logger.swift
//  
//
//  Created by Andrew Barba on 1/12/22.
//

import FastlyWorld

extension Fastly {
    public struct Logger: Sendable {

        internal let handle: WasiHandle

        public init(name: String) throws {
            var handle: WasiHandle = 0
            var name_t = name.fastly_world_t
            try fastlyWorld {err in
                fastly_log_endpoint_get(&name_t, &handle, &err)
            }
            self.handle = handle
        }

        public func write(_ messages: String...) throws {
            let message = messages.joined(separator: " ")
            var message_t = message.fastly_world_t
            try fastlyWorld { err in
                fastly_log_write(handle, &message_t, &err)
            }
        }

        public func write<T>(
            _ value: T,
            encoder: JSONEncoder = .init(),
            formatting: JSONEncoder.OutputFormatting = [.sortedKeys]
        ) throws where T: Encodable {
            encoder.outputFormatting = formatting
            let data = try encoder.encode(value)
            return try write(data)
        }

        public func write(
            _ jsonObject: [String: Any],
            options: JSONSerialization.WritingOptions = [.sortedKeys]
        ) throws {
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: options)
            return try write(data)
        }

        public func write(
            _ jsonArray: [Any],
            options: JSONSerialization.WritingOptions = [.sortedKeys]
        ) throws {
            let data = try JSONSerialization.data(withJSONObject: jsonArray, options: options)
            return try write(data)
        }

        public func write(_ data: Data) throws {
            let text = String(bytes: data, encoding: .utf8) ?? ""
            return try write(text)
        }
    }
}
