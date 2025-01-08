//
//  FetchTests.swift
//
//
//  Created by Andrew Barba on 11/27/22.
//

import XCTest

@testable import Compute

final class FetchTests: XCTestCase {

    struct TestResponse: Decodable {
        struct Slideshow: Decodable {
            let title: String
            let author: String
        }

        let slideshow: Slideshow
    }

    func testFetch() async throws {
        let res: TestResponse = try await fetch("https://httpbin.org/json").decode()
        XCTAssertEqual(res.slideshow.title, "Sample Slide Show")
        XCTAssertEqual(res.slideshow.author, "Yours Truly")
    }
}
