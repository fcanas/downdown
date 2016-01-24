//
//  BlockElementTests.swift
//  SwiftDown
//
//  Created by Fabian Canas on 1/19/16.
//  Copyright © 2016 Fabián Cañas. All rights reserved.
//

import XCTest
@testable import SwiftDown

class HeaderTests: XCTestCase {
    func testLevels() {
        let (h1, _) = header("# this is a header")
        XCTAssertEqual(h1.map(html)!, "<h1>this is a header</h1>")

        let (h2, _) = header("## this is a header")
        XCTAssertEqual(h2.map(html)!, "<h2>this is a header</h2>")

        let (h3, _) = header("### this is a header")
        XCTAssertEqual(h3.map(html)!, "<h3>this is a header</h3>")
    }
    
    func testFormattingInsideHeader() {
        let (h1, _) = header("# Header with *emphasis*")
        XCTAssertEqual(h1.map(html)!, "<h1>Header with <em>emphasis</em></h1>")
    }
}

