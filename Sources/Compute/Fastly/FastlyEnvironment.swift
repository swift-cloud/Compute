//
//  FastlyEnvironment.swift
//
//
//  Created by Andrew Barba on 1/12/22.
//

extension Fastly {
    public struct Environment: Sendable {

        public static let current = Environment()

        public func get(_ key: String) -> String? {
            return ProcessInfo.processInfo.environment[key]
        }

        public func get(_ key: String, default value: String) -> String {
            return ProcessInfo.processInfo.environment[key, default: value]
        }

        public subscript(key: String) -> String? {
            return self.get(key)
        }

        public subscript(key: String, default value: String) -> String {
            return self.get(key, default: value)
        }
    }
}

extension Fastly.Environment {
    public static let cacheGeneration = current["FASTLY_CACHE_GENERATION"] ?? "local"

    public static let customerId = current["FASTLY_CUSTOMER_ID"] ?? "local"

    public static let hostname = current["FASTLY_HOSTNAME"] ?? "localhost"

    public static let pop = current["FASTLY_POP"] ?? "local"

    public static let region = current["FASTLY_REGION"] ?? "local"

    public static let serviceId = current["FASTLY_SERVICE_ID"] ?? "local"

    public static let serviceVersion = current["FASTLY_SERVICE_VERSION"] ?? "0"

    public static let traceId = current["FASTLY_TRACE_ID"] ?? "local"

    public static var viceroy: Bool {
        return hostname == "localhost"
    }
}
