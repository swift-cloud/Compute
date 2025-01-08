//
//  Range.swift
//
//
//  Created by Andrew Barba on 1/18/22.
//

public typealias FixedRange = (start: Int, end: Int)

public enum RangeInterval: Sendable {
    case open(start: Int)
    case closed(start: Int, end: Int)
    case suffix(length: Int)

    public func fixed(totalLength: Int) -> FixedRange {
        switch self {
        case .open(let start):
            return (start, totalLength)
        case .closed(let start, let end):
            return (start, end)
        case .suffix(let length):
            return (totalLength - length, totalLength)
        }
    }
}

public struct Range: Sendable {

    public let unit: String

    public let intervals: [RangeInterval]

    public init(unit: String, intervals: [RangeInterval]) {
        self.unit = unit
        self.intervals = intervals
    }

    public init?(from value: String) {
        // Split on equals to get [<unit>, <start>-<end>]
        let valueParts = value.components(separatedBy: "=").map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        // Ensure only two parts
        guard valueParts.count == 2 else {
            return nil
        }

        // Parse unit
        let unit = valueParts[0]

        // Parse intervals parts to get [<start>-<end>, ...]
        let intervalsParts = valueParts[1].components(separatedBy: ",").map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        // Map over intervals parts to create intervals
        let intervals = intervalsParts.compactMap { part -> RangeInterval? in

            // Split part on - to get [<start>, <end>]
            let intervalParts = part.components(separatedBy: "-").map {
                $0.trimmingCharacters(in: .whitespacesAndNewlines)
            }

            // Ensure exactly two parts
            guard intervalParts.count == 2 else {
                return nil
            }

            // Parse start interval
            let start = Int(intervalParts[0])

            // Parse end interval
            let end = Int(intervalParts[1])

            // Build type of range
            switch (start, end) {
            case (.some(let startValue), .some(let endValue)):
                return .closed(start: startValue, end: endValue)
            case (.some(let startValue), .none):
                return .open(start: startValue)
            case (.none, .some(let endValue)):
                return .suffix(length: endValue)
            default:
                return nil
            }
        }

        // Ensure we have at least one interval
        guard intervals.count > 0 else {
            return nil
        }

        // Set values
        self.unit = unit
        self.intervals = intervals
    }
}
