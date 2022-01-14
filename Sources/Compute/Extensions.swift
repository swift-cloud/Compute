//
//  File.swift
//  
//
//  Created by Andrew Barba on 1/14/22.
//

extension Array {

    internal func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
