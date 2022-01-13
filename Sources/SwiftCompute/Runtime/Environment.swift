//
//  File.swift
//  
//
//  Created by Andrew Barba on 1/12/22.
//

import Foundation

public struct Environment {

    public static func get(_ key: String) -> String? {
        guard let pointer = getenv(key) else {
            return nil
        }
        return String(cString: pointer)
    }
}

extension Environment {
    public struct Compute {
        public static let cacheGeneration = Environment.get("FASTLY_CACHE_GENERATION") ?? "local"

        public static let customerId = Environment.get("FASTLY_CUSTOMER_ID") ?? "local"

        public static let hostname = Environment.get("FASTLY_HOSTNAME") ?? "localhost"

        public static let pop = Environment.get("FASTLY_POP") ?? "local"

        public static let region = Environment.get("FASTLY_REGION") ?? "local"

        public static let serviceId = Environment.get("FASTLY_SERVICE_ID") ?? "local"

        public static let serviceVersion = Environment.get("FASTLY_SERVICE_VERSION") ?? "0"

        public static let traceId = Environment.get("FASTLY_TRACE_ID") ?? "local"
    }
}
