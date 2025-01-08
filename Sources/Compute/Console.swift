//
//  Console.swift
//
//
//  Created by Andrew Barba on 3/23/22.
//

public let console = Console()

public struct Console: Sendable {

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
        var errorStream = StandardErrorOutputStream()
        let text = items.map { String(describing: $0) }.joined(separator: " ")
        if let prefix = prefix {
            print(prefix, text, to: &errorStream)
        } else {
            print(text, to: &errorStream)
        }
    }
}

private struct StandardErrorOutputStream: TextOutputStream {

    private let stderr = FileHandle.standardError

    func write(_ string: String) {
        guard let data = string.data(using: .utf8) else {
            return
        }
        stderr.write(data)
    }
}
