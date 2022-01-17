//
//  File.swift
//  
//
//  Created by Andrew Barba on 1/16/22.
//

extension Collection {

    func mapAsync<T>(_ handler: @escaping (Element) async throws -> T) async rethrows -> [T] {
        try await withThrowingTaskGroup(of: (index: Int, value: T).self, returning: [T].self) { group in
            var results = Array<T?>(repeating: nil, count: self.count)
            for (index, item) in self.enumerated() {
                group.addTask(priority: .high) {
                    return (index, try await handler(item))
                }
            }
            for try await result in group {
                results[result.index] = result.value
            }
            return results as! [T]
        }
    }
}
