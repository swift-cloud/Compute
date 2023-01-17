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
    public static var cacheGeneration = current["FASTLY_CACHE_GENERATION"] ?? "local"

    public static var customerId = current["FASTLY_CUSTOMER_ID"] ?? "local"

    public static var hostname = current["FASTLY_HOSTNAME"] ?? "localhost"

    public static var pop = current["FASTLY_POP"] ?? "local"

    public static var region = current["FASTLY_REGION"] ?? "local"

    public static var serviceId = current["FASTLY_SERVICE_ID"] ?? "local"

    public static var serviceVersion = current["FASTLY_SERVICE_VERSION"] ?? "0"

    public static var traceId = current["FASTLY_TRACE_ID"] ?? "local"

    public static var viceroy: Bool {
        return hostname == "localhost"
    }
}
