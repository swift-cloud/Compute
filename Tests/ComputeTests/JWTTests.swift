//
//  JWTTests.swift
//  
//
//  Created by Andrew Barba on 11/27/22.
//

import XCTest
@testable import Compute

private let token =
"""
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
"""

final class JWTTests: XCTestCase {

    func testVerifySuccess() throws {
        let jwt = try JWT(token)
        try jwt.verify(secret: "your-256-bit-secret")
    }

    func testVerifyFailure() throws {
        let jwt = try JWT(token)
        try XCTAssertThrowsError(jwt.verify(secret: "bogus-secret"))
    }

    func testSubject() throws {
        let jwt = try JWT(token)
        XCTAssertNotNil(jwt.subject)
        XCTAssertEqual(jwt.subject, "1234567890")
    }

    func testClaim() throws {
        let jwt = try JWT(token)
        XCTAssertNotNil(jwt["name"].string)
        XCTAssertEqual(jwt["name"].string, "John Doe")
    }
}
