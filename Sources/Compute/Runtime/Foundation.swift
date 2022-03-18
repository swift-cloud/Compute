//
//  Foundation.swift
//  
//
//  Created by Andrew Barba on 3/18/22.
//

import Foundation

extension Data: @unchecked Sendable {}

extension JSONEncoder: @unchecked Sendable {}

extension JSONDecoder: @unchecked Sendable {}

extension URL: @unchecked Sendable {}
