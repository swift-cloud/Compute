//
//  LocalStore.swift
//  
//
//  Created by Andrew Barba on 3/30/22.
//

public func LocalStore() throws -> ObjectStore {
    try .init(name: localStoreName)
}
