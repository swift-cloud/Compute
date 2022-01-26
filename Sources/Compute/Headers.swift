//
//  Headers.swift
//  
//
//  Created by Andrew Barba on 1/16/22.
//

public protocol HeadersProvider: Sendable {

    func getHeaderNames() throws -> [String]

    func getHeader(_ name: String) throws -> String?

    mutating func insertHeader(_ name: String, _ value: String) throws

    mutating func appendHeader(_ name: String, _ value: String) throws

    mutating func removeHeader(_ name: String) throws
}

extension HttpRequest: HeadersProvider {}

extension HttpResponse: HeadersProvider {}

public struct Headers<T>: Sendable where T: HeadersProvider {

    internal private(set) var instance: T

    internal init(_ instance: T) {
        self.instance = instance
    }

    public func keys() -> [String] {
        let keys = try? instance.getHeaderNames()
        return keys ?? []
    }

    public func values() -> [String] {
        return keys().compactMap { get($0) }
    }

    public func entries() -> [(key: String, value: String)] {
        return keys().compactMap { key in
            guard let value = get(key), value.count > 0 else {
                return nil
            }
            return (key, value)
        }
    }

    public func dictionary() -> [String: String] {
        return keys().reduce(into: [:]) { dict, key in
            dict[key] = get(key)
        }
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
        get { self.get(name) }
        set { self.set(name, newValue) }
    }

    public subscript(name: String, default value: String) -> String {
        self.get(name) ?? value
    }

    public subscript(name: HttpHeader) -> String? {
        get { self.get(name.rawValue) }
        set { self.set(name.rawValue, newValue) }
    }

    public subscript(name: HttpHeader, default value: String) -> String {
        self.get(name.rawValue) ?? value
    }
}
