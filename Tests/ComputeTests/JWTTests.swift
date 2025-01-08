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
    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2Njk1OTE2MTEsIm5hbWUiOiJKb2huIERvZSIsInN1YiI6IjEyMzQ1Njc4OTAifQ.FUVIl48Ji1mWZa42K1OTG0x_2T0FYOXNACsmeNI2-Kc
    """

private let fanoutToken =
    """
    eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJleHAiOjE2NzUzNjU0MjgsImlzcyI6ImZhc3RseSJ9.QL2Pm1JnXV_vAYK7ijeD4U1CBjOTLihNMDZ-qfvjkKOTUiK1jyxGEwjZfeApijRaOtQT8fVkdPnKjF-tBiUzkA
    """

final class JWTTests: XCTestCase {

    func testVerifySuccess() throws {
        let jwt = try JWT(token: token)
        try jwt.verify(key: "your-256-bit-secret", expiration: false)
    }

    func testVerifyFanoutSuccess() throws {
        let jwt = try JWT(token: fanoutToken)
        try jwt.verify(key: fanoutPublicKey, expiration: false)
    }

    func testVerifyFailure() throws {
        let jwt = try JWT(token: token)
        try XCTAssertThrowsError(jwt.verify(key: "bogus-secret"))
    }

    func testAlgorithm() throws {
        let jwt = try JWT(token: token)
        XCTAssertEqual(jwt.algorithm, JWT.Algorithm.hs256)
    }

    func testSubject() throws {
        let jwt = try JWT(token: token)
        XCTAssertNotNil(jwt.subject)
        XCTAssertEqual(jwt.subject, "1234567890")
    }

    func testClaim() throws {
        let jwt = try JWT(token: token)
        XCTAssertNotNil(jwt["name"].string)
        XCTAssertEqual(jwt["name"].string, "John Doe")
    }

    func testCreate() throws {
        let jwt = try JWT(
            claims: ["name": "John Doe"],
            secret: "your-256-bit-secret",
            issuedAt: Date(timeIntervalSince1970: 1_669_591_611),
            subject: "1234567890"
        )
        XCTAssertEqual(jwt.token, token)
    }
}
