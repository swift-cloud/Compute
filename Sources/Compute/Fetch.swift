//
//  Fetch.swift
//  
//
//  Created by Andrew Barba on 1/15/22.
//

import Foundation

public func fetch(_ url: URL, _ options: FetchRequest.Options = .options()) async throws -> FetchResponse {
    let request = try FetchRequest(url, options)
    return try await request.send()
}

public func fetch(_ urlPath: String, _ options: FetchRequest.Options = .options()) async throws -> FetchResponse {
    guard let url = URL(string: urlPath) else {
        throw FetchRequestError.invalidURL
    }
    let request = try FetchRequest(url, options)
    return try await request.send()
}
