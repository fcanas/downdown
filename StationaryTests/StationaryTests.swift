//
//  StationaryTests.swift
//  StationaryTests
//
//  Created by Fabian Canas on 2/27/16.
//  Copyright © 2016 Fabián Cañas. All rights reserved.
//

import XCTest
@testable import Stationary

class TokenSplitTests: XCTestCase {
    
    func testSimpleSplit() {
        let testString = "Hi.there"
        
        let (pre, post) = split(testString, token: ".")
        
        let preString = testString.substringWithRange(pre)
        let postString = testString.substringWithRange(post)
        
        XCTAssertEqual(preString, "Hi")
        XCTAssertEqual(postString, "there")
    }
    
    func testNoPrefixSplit() {
        let testString = ".there"
        
        let (pre, post) = split(testString, token: ".")
        
        let preString = testString.substringWithRange(pre)
        let postString = testString.substringWithRange(post)
        
        XCTAssertEqual(preString, "")
        XCTAssertEqual(postString, "there")
    }
    
    func testNoPostfixSplit() {
        let testString = "there."
        
        let (pre, post) = split(testString, token: ".")
        
        let preString = testString.substringWithRange(pre)
        let postString = testString.substringWithRange(post)
        
        XCTAssertEqual(preString, "there")
        XCTAssertEqual(postString, "")
    }
    
    func testSingleToken() {
        let testString = "One.two.three"
        
        let (pre, post) = split(testString, token: ".")
        
        let preString = testString.substringWithRange(pre)
        let postString = testString.substringWithRange(post)
        
        XCTAssertEqual(preString, "One")
        XCTAssertEqual(postString, "two.three")
    }
    
    func testRangedSplitting() {
        let testString = "One.two.three"
        
        let (pre, post) = split(testString, token: ".", range: testString.startIndex.advancedBy(4) ..< testString.endIndex)
        
        let preString = testString.substringWithRange(pre)
        let postString = testString.substringWithRange(post)
        
        XCTAssertEqual(preString, "two")
        XCTAssertEqual(postString, "three")
    }
    
    func testNotFound() {
        let testString = "One two three"
        
        let (pre, post) = split(testString, token: ".")
        
        let preString = testString.substringWithRange(pre)
        let postString = testString.substringWithRange(post)
        
        XCTAssertEqual(preString, "One two three")
        XCTAssertEqual(postString, "")
    }
    
    func testRangedNotFound() {
        let testString = "One two three"
        
        let (pre, post) = split(testString, token: ".", range: testString.startIndex.advancedBy(4) ..< testString.endIndex.advancedBy(-3))
        
        let preString = testString.substringWithRange(pre)
        let postString = testString.substringWithRange(post)
        
        XCTAssertEqual(preString, "two th")
        XCTAssertEqual(postString, "")
    }
}

class TemplateTests : XCTestCase {
    func testSimpleTemplate() {
        let templateString = "My name is {{ name }}, and I am {{ age }} years old."
        
        let template = Template(templateString: templateString)
        switch template {
        case .Complete:
            XCTFail()
        case let .Incomplete(items):
            XCTAssertEqual(items.count, 5)
        }
        
        let hydratedTemplate = template.hydrate(["name":"Bilbo", "age":"111"])
        switch hydratedTemplate {
        case let .Complete(items):
            XCTAssertEqual(items.count, 5)
        case .Incomplete:
            XCTFail()
        }
        
        XCTAssertEqual(try? hydratedTemplate.render(), "My name is Bilbo, and I am 111 years old.")
    }
}
