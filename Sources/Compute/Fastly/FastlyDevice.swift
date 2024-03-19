//
//  FastlyDevice.swift
//
//
//  Created by Andrew Barba on 3/19/24.
//

import ComputeRuntime

extension Fastly {
    public struct Device: Sendable {

        public struct DeviceLookup: Codable, Sendable {
            public let name: String?
            public let brand: String?
            public let model: String?
            public let hardwareType: String?
            public let isDesktop: Bool?
            public let isGameConsole: Bool?
            public let isMediaPlayer: Bool?
            public let isMobile: Bool?
            public let isSmartTV: Bool?
            public let isTablet: Bool?
            public let isTouchscreen: Bool?
        }

        public static func lookup(userAgent: String) throws -> DeviceLookup {
            return try wasiDecode(maxBufferLength: maxIpLookupLength) {
                fastly_device__device_detection_lookup(userAgent, userAgent.utf8.count, $0, $1, &$2)
            }
        }

        private init() {}
    }
}
