//
//  Environment.swift
//  
//
//  Created by Andrew Barba on 1/12/22.
//

import Foundation

public struct Environment: Sendable {
    
    public static func get(_ key: String) -> String? {
        guard let pointer = getenv(key) else {
            return nil
        }
        return String(cString: pointer)
    }

    public static subscript(key: String) -> String? {
        return self.get(key)
    }

    public static subscript(key: String, default value: String) -> String {
        return self.get(key) ?? value
    }
}

extension Environment {
    
    public struct Compute {
        
        public static let cacheGeneration = Environment["FASTLY_CACHE_GENERATION", default: "local"]
        
        public static let customerId = Environment["FASTLY_CUSTOMER_ID", default: "local"]
        
        public static let hostname = Environment["FASTLY_HOSTNAME", default: "localhost"]
        
        public static let pop = Environment["FASTLY_POP", default: "local"]
        
        public static let region = Environment["FASTLY_REGION", default: "local"]
        
        public static let serviceId = Environment["FASTLY_SERVICE_ID", default: "local"]
        
        public static let serviceVersion = Environment["FASTLY_SERVICE_VERSION", default: "0"]
        
        public static let traceId = Environment["FASTLY_TRACE_ID", default: "local"]
    }
}
