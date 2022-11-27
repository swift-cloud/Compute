//
//  JWTTests.swift
//  
//
//  Created by Andrew Barba on 11/27/22.
//

import XCTest
@testable import Compute

final class JWTTests: XCTestCase {

    func testVerify() throws {
        let jwt = try JWT(
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        )
        try jwt.verify(secret: "your-256-bit-secret")
    }
}
