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

extension Fastly.Request: HeadersProvider {}

extension Fastly.Response: HeadersProvider {}

extension HTTPHeaders: HeadersProvider {

    public func getHeaderNames() throws -> [String] {
        self.enumerated().map { $1.key }
    }

    public func getHeader(_ name: String) throws -> String? {
        self[name]
    }

    public mutating func insertHeader(_ name: String, _ value: String) throws {
        self[name] = value
    }

    public mutating func appendHeader(_ name: String, _ value: String) throws {
        self[name] = value
    }

    public mutating func removeHeader(_ name: String) throws {
        self[name] = nil
    }
}

public struct Headers: Sendable {

    internal private(set) var instance: HeadersProvider

    internal init(_ instance: HeadersProvider) {
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

    public func dictionary() -> HTTPHeaders {
        return keys().reduce(into: [:]) { dict, key in
            dict[key] = get(key)
        }
    }

    public func get(_ name: HTTPHeader) -> String? {
        return get(name.rawValue)
    }

    public func get(_ name: String) -> String? {
        guard has(name) else {
            return nil
        }
        return try? instance.getHeader(name.lowercased())
    }

    public func has(_ name: HTTPHeader) -> Bool {
        return has(name.rawValue)
    }

    public func has(_ name: String) -> Bool {
        return keys().contains(name.lowercased())
    }

    public mutating func set(_ name: HTTPHeader, _ value: String?) {
        set(name.rawValue, value)
    }

    public mutating func set(_ name: String, _ value: String?) {
        if let value = value {
            try? instance.insertHeader(name.lowercased(), value)
        } else if has(name) {
            try? instance.removeHeader(name.lowercased())
        }
    }

    public mutating func append(_ name: HTTPHeader, _ value: String) {
        append(name.rawValue, value)
    }

    public mutating func append(_ name: String, _ value: String) {
        try? instance.appendHeader(name.lowercased(), value)
    }

    public mutating func delete(_ name: HTTPHeader) {
        delete(name.rawValue)
    }

    public mutating func delete(_ name: String) {
        try? instance.removeHeader(name.lowercased())
    }

    public subscript(name: String) -> String? {
        get { self.get(name) }
        set { self.set(name, newValue) }
    }

    public subscript(name: String, default value: String) -> String {
        self.get(name) ?? value
    }

    public subscript(name: HTTPHeader) -> String? {
        get { self.get(name.rawValue) }
        set { self.set(name.rawValue, newValue) }
    }

    public subscript(name: HTTPHeader, default value: String) -> String {
        self.get(name.rawValue) ?? value
    }
}
