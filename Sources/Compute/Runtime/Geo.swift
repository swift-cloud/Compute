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
    
    public static func lookup(ip: IpAddress) throws -> IpLookup {
        switch ip {
        case .v4(let text):
            let bytes = text.components(separatedBy: ".").compactMap { UInt8($0) }
            return try lookup(ip: bytes)
        case .v6(let text):
            let bytes = text.components(separatedBy: ":").reduce(Array<UInt8>()) { res, octet in
                let first = octet.prefix(2)
                let second = octet.suffix(2)
                return res + [UInt8(first, radix: 16), UInt8(second, radix: 16)].compactMap { $0 }
            }
            return try lookup(ip: bytes)
        }
    }
    
    public static func lookup(ip bytes: [UInt8]) throws -> IpLookup {
        return try wasiDecode(IpLookup.self) {
            fastly_geo__lookup(bytes, bytes.count, $0, $1, &$2)
        }
    }
}
