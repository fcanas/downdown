//
//  SpanElementTests.swift
//  SwiftDown
//
//  Created by Fabian Canas on 1/18/16.
//  Copyright © 2016 Fabián Cañas. All rights reserved.
//

import XCTest
@testable import SwiftDown

class LineTests: XCTestCase {
    func testBasicLine() {
        let (l, output) = line("This is a line")
        XCTAssertEqual(output, "")
        XCTAssertEqual(l.content.count, 1)
    }
    
    func testLineWithEmphasis() {
        let (l, output) = line("This *is* a line")
        XCTAssertEqual(l.content.count, 3)
        XCTAssertEqual(output, "")
        XCTAssertEqual(html(l), "This <em>is</em> a line")
    }
    
    func testLineWithMultipleEmphasis() {
        let (l, output) = line("This *is* a line with *emphasis*!")
        XCTAssertEqual(l.content.count, 5)
        XCTAssertEqual(output, "")
        XCTAssertEqual(html(l), "This <em>is</em> a line with <em>emphasis</em>!")
    }
    
    func testLineWithMultipleCode() {
        let (l, output) = line("This `is` a line with `code`!")
        XCTAssertEqual(l.content.count, 5)
        XCTAssertEqual(output, "")
        XCTAssertEqual(html(l), "This <code>is</code> a line with <code>code</code>!")
    }
    
    func testLineWithEmphasisCode() {
        let (l, output) = line("This *is* some `code`!")
        XCTAssertEqual(l.content.count, 5)
        XCTAssertEqual(output, "")
        XCTAssertEqual(html(l), "This <em>is</em> some <code>code</code>!")
    }
    
    func testLineWithEmphasisCodeLink() {
        let (l, output) = line("This *is* a [link](code.html) to some `code`!")
        XCTAssertEqual(l.content.count, 7)
        XCTAssertEqual(output, "")
        XCTAssertEqual(html(l), "This <em>is</em> a <a href=\"code.html\">link</a> to some <code>code</code>!")
    }
    
    func testLineWithEmphasisCodeLinkImage() {
        let (l, output) = line("This *is* a [link](code.html) to some ![sample code](code.png) `code`!")
        XCTAssertEqual(l.content.count, 9)
        XCTAssertEqual(output, "")
        XCTAssertEqual(html(l), "This <em>is</em> a <a href=\"code.html\">link</a> to some <img alt=\"sample code\" src=\"code.png\"> <code>code</code>!")
    }
}

class LinkTests: XCTestCase {
    func testLink() {
        let (linkElement, output) = link("[link text](http://www.google.com)")
        XCTAssertEqual(html(linkElement!), "<a href=\"http://www.google.com\">link text</a>")
        XCTAssertEqual(output, "")
    }
    
    func testNotALink() {
        let input = "A sentence with a [link](http://www.google.com)"
        let (linkElement, output) = link(input)
        XCTAssertNil(linkElement)
        XCTAssertEqual(input, output)
    }
}

class EmphasisTests: XCTestCase {
    func testEmphasis() {
        let (emElement, output) = emphasis("*Text to emphasize*")
        XCTAssertEqual(html(emElement!), "<em>Text to emphasize</em>")
        XCTAssertEqual(output, "")
    }
    
    func testNotEmphasis() {
        let input = "Not exactly *text to emphasize*"
        let (emElement, output) = emphasis(input)
        XCTAssertNil(emElement)
        XCTAssertEqual(input, output)
    }
}

class CodeTests: XCTestCase {
    func testCode() {
        let (codeElement, output) = code("`let this = code`")
        XCTAssertEqual(html(codeElement!), "<code>let this = code</code>")
        XCTAssertEqual(output, "")
    }
    
    func testNotCode() {
        let input = "Not exactly `let this = code`"
        let (codeElement, output) = code(input)
        XCTAssertNil(codeElement)
        XCTAssertEqual(input, output)
    }
}

class ImageTests: XCTestCase {
    func testImage() {
        let (imgElement, output) = image("![alt text](http://www.google.com)")
        XCTAssertEqual(html(imgElement!), "<img alt=\"alt text\" src=\"http://www.google.com\">")
        XCTAssertEqual(output, "")
    }
    
    func testImageWithTitle() {
        let (imgElement, output) = image("![alt text](http://www.google.com \"Title\")")
        XCTAssertEqual(html(imgElement!), "<img alt=\"alt text\" src=\"http://www.google.com\" title=\"Title\">")
        XCTAssertEqual(output, "")
    }
    
    func testNotAnImage() {
        let input = "A sentence with an ![image](http://www.google.com)"
        let (imgElement, output) = image(input)
        XCTAssertNil(imgElement)
        XCTAssertEqual(input, output)
    }
}

