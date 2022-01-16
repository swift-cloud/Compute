//
//  Headers.swift
//  
//
//  Created by Andrew Barba on 1/16/22.
//

public protocol HeadersRepresentable {

    func getHeader(_ name: String) throws -> String?

    mutating func insertHeader(_ name: String, _ value: String) throws

    mutating func appendHeader(_ name: String, _ value: String) throws

    mutating func removeHeader(_ name: String) throws
}

extension HttpRequest: HeadersRepresentable {}

extension HttpResponse: HeadersRepresentable {}

public struct Headers<T> where T: HeadersRepresentable {

    internal private(set) var instance: T

    internal init(_ instance: T) {
        self.instance = instance
    }

    public func get(_ name: String) -> String? {
        return try? instance.getHeader(name)
    }

    public func has(_ name: String) -> Bool {
        guard let value = get(name) else {
            return false
        }
        return value.count > 0
    }

    public mutating func set(_ name: String, _ value: String?) {
        if let value = value {
            try? instance.insertHeader(name, value)
        } else if has(name) {
            try? instance.removeHeader(name)
        }
    }

    public mutating func append(_ name: String, _ value: String) {
        try? instance.appendHeader(name, value)
    }

    public mutating func delete(_ name: String) {
        try? instance.removeHeader(name)
    }

    public subscript(name: String) -> String? {
        get { get(name) }
        set { set(name, newValue) }
    }
}
