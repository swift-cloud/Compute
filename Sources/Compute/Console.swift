//
//  Console.swift
//  
//
//  Created by Andrew Barba on 3/23/22.
//

import Foundation

public let console = Console()

public struct Console {

    public var prefix: String? = nil

    public init(prefix: String? = nil) {
        self.prefix = prefix
    }

    public func log(_ items: Any...) {
        let text = items.map { String(describing: $0) }.joined(separator: " ")
        if let prefix = prefix {
            print(prefix, text)
        } else {
            print(text)
        }
    }

    public func error(_ items: Any...) {
        let text = items.map { String(describing: $0) }.joined(separator: " ")
        if let prefix = prefix {
            print(prefix, text, to: &StandardErrorOutputStream.default)
        } else {
            print(text, to: &StandardErrorOutputStream.default)
        }
    }
}

fileprivate struct StandardErrorOutputStream: TextOutputStream {

    fileprivate static var `default` = StandardErrorOutputStream()

    private let stderr = FileHandle.standardError

    func write(_ string: String) {
        guard let data = string.data(using: .utf8) else {
            return
        }
        stderr.write(data)
    }
}
