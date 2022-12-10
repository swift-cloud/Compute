//
//  FastlyEnvironment.swift
//  
//
//  Created by Andrew Barba on 1/12/22.
//

extension Fastly {
    public struct Environment: Sendable {

        public static func get(_ key: String) -> String? {
            return ProcessInfo.processInfo.environment[key]
        }

        public static subscript(key: String) -> String? {
            return self.get(key)
        }

        public static subscript(key: String, default value: String) -> String {
            return self.get(key) ?? value
        }

        private init() {}
    }
}

extension Fastly.Environment {
    public static var cacheGeneration = Self["FASTLY_CUSTOMER_ID", default: "local"]

    public static var customerId = Self["FASTLY_CUSTOMER_ID", default: "local"]

    public static var hostname = Self["FASTLY_HOSTNAME", default: "localhost"]

    public static var pop = Self["FASTLY_POP", default: "local"]

    public static var region = Self["FASTLY_REGION", default: "local"]

    public static var serviceId = Self["FASTLY_SERVICE_ID", default: "local"]

    public static var serviceVersion = Self["FASTLY_SERVICE_VERSION", default: "0"]

    public static var traceId = Self["FASTLY_TRACE_ID", default: "local"]

    public static var viceroy: Bool {
        return serviceId == "local"
    }
}
