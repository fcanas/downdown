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

class HorizontalRuleTests: XCTestCase {
    
    func testHRule() {
        // Hyphen
        let (hr0, _) = horizontalRule("--------")
        XCTAssertEqual(hr0.map(html)!, "<hr />")
        
        let (hr1, _) = horizontalRule("---")
        XCTAssertEqual(hr1.map(html)!, "<hr />")

        // Underscore
        let (hr2, _) = horizontalRule("________")
        XCTAssertEqual(hr2.map(html)!, "<hr />")
        
        let (hr3, _) = horizontalRule("___")
        XCTAssertEqual(hr3.map(html)!, "<hr />")

        // Asterisk
        let (hr4, _) = horizontalRule("*********")
        XCTAssertEqual(hr4.map(html)!, "<hr />")
        
        let (hr5, _) = horizontalRule("***")
        XCTAssertEqual(hr5.map(html)!, "<hr />")
    }
    
    func testHRuleSupportSpaces() {
        let (hr0, _) = horizontalRule("- - -")
        XCTAssertEqual(hr0.map(html)!, "<hr />")
        
        let (hr1, _) = horizontalRule("_ _ _")
        XCTAssertEqual(hr1.map(html)!, "<hr />")

        let (hr2, _) = horizontalRule("* * *")
        XCTAssertEqual(hr2.map(html)!, "<hr />")
    }
    
    func testMinimumOf3() {
        let (hr0, _) = horizontalRule("--")
        XCTAssertNil(hr0)
        
        let (hr1, _) = horizontalRule("__")
        XCTAssertNil(hr1)
        
        let (hr2, _) = horizontalRule("**")
        XCTAssertNil(hr2)
    }
}
