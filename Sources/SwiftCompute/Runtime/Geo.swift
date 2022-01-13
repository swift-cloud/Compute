//
//  Geo.swift
//  
//
//  Created by Andrew Barba on 1/12/22.
//

import ComputeRuntime
import Foundation

public struct Geo {
    
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
        public let latitude: Double?
        public let longitude: Double?
        public let metroCode: Int?
        public let postalCode: String?
        public let proxyDescription: String?
        public let proxyType: String?
        public let region: String?
        public let utcOffset: Int?
    }
    
    public static func lookup(ipV4: String) throws -> IpLookup {
        let digits = ipV4.components(separatedBy: ".").compactMap { UInt8($0) }
        return try lookup(ip: digits)
    }
    
    public static func lookup(ip: [UInt8]) throws -> IpLookup {
        var length: Int32 = 0
        try wasi(fastly_geo__lookup(ip, .init(ip.count), nil, maxBufferLength, &length))
        let bytes = try Array<UInt8>(unsafeUninitializedCapacity: .init(length)) {
            try wasi(fastly_geo__lookup(ip, .init(ip.count), $0.baseAddress, length, nil))
            $1 = .init(length)
        }
        return try Utils.jsonDecoder.decode(IpLookup.self, from: .init(bytes))
    }
}
