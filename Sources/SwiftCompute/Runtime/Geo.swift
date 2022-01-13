//
//  Geo.swift
//  
//
//  Created by Andrew Barba on 1/12/22.
//

import ComputeRuntime
import Foundation

public struct Geo {

    private static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    public struct IpLookup: Codable {
        public let asName: String?
        public let asNumber: Int?
        public let areaCode: Int?
        public let city: String?
        public let connSpeed: String?
        public let connType: String?
        public let continent: String?
        public let countryCode: String?
        public let countryCode3: String?
        public let countryName: String?
        public let gmtOffset: Int?
        public let latitude: Int?
        public let longitude: Int?
        public let metroCode: Int?
        public let postalCode: String?
        public let proxyDescription: String?
        public let proxyType: String?
        public let region: String?
        public let utcOffset: Int?
    }

    public static func lookup(ip: [UInt8]) throws -> Any? {
        var digits = ip
        var buffer = Array<UInt8>(repeating: 0, count: 1024)
        var result: Int32 = 0
        try wasi(fastly_geo__lookup(&digits, Int32(digits.count), &buffer, Int32(buffer.count), &result))
        return try jsonDecoder.decode(IpLookup.self, from: .init(buffer))
    }
}
