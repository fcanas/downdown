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
        
        let (h4, _) = header("#### this is a header")
        XCTAssertEqual(h4.map(html)!, "<h4>this is a header</h4>")
        
        let (h5, _) = header("##### this is a header")
        XCTAssertEqual(h5.map(html)!, "<h5>this is a header</h5>")
        
        let (h6, _) = header("###### this is a header")
        XCTAssertEqual(h6.map(html)!, "<h6>this is a header</h6>")
        
        // headers only go up to level 6
        
        let (h7, _) = header("####### this is a header")
        XCTAssertNil(h7)
        
        let (h8, _) = header("######## this is a header")
        XCTAssertNil(h8)
    }
    
    func testFormattingInsideHeader() {
        let (h1, _) = header("# Header with *emphasis*")
        XCTAssertEqual(h1.map(html)!, "<h1>Header with <em>emphasis</em></h1>")
    }
    
    func testStringAdvancing() {
        let (h1, output) = header("# this is a header\n")
        XCTAssertEqual(h1.map(html)!, "<h1>this is a header</h1>")
        XCTAssertEqual(output, "")
    }
    
    func testDontBeGreedy() {
        let (h1, _) = header("# Title\n\n## Subtitle")
        XCTAssertEqual(html(h1!), "<h1>Title</h1>")
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

class Paragraph: XCTestCase {
    
    func testParagraph() {
        let (p, _) = paragraph("This is\na paragraph\nwith words.\n\n")
        XCTAssertEqual(p.map(html)!, "<p>This is\na paragraph\nwith words.</p>")
    }
    
    func testParagraphWithSpaces() {
        let (p, _) = paragraph("This is\na paragraph\nwith words.\n  \t\n")
        XCTAssertEqual(p.map(html)!, "<p>This is\na paragraph\nwith words.</p>")
    }
    
    func testParagraphWithSpanFormatting() {
        let (p, _) = paragraph("This is\na [paragraph](paragraph.html)\nwith *formatting*.\n\n")
        XCTAssertEqual(p.map(html)!, "<p>This is\na <a href=\"paragraph.html\">paragraph</a>\nwith <em>formatting</em>.</p>")
    }
    
}

class BlockquoteTests: XCTestCase {
    
    func testBlockQuote() {
        let (p, _) = blockQuote("> This is\na paragraph\nwith words.\n\n")
        XCTAssertEqual(p.map(html)!, "<blockquote><p>This is\na paragraph\nwith words.</p></blockquote>")
    }
    
    func testBlockQuoteWithSpaces() {
        let (p, _) = blockQuote("> This is\na paragraph\nwith words.\n  \t\n")
        XCTAssertEqual(p.map(html)!, "<blockquote><p>This is\na paragraph\nwith words.</p></blockquote>")
    }
    
    func testBlockQuoteWithSpanFormatting() {
        let (p, _) = blockQuote("> This is\na [paragraph](paragraph.html)\nwith *formatting*.\n\n")
        XCTAssertEqual(p.map(html)!, "<blockquote><p>This is\na <a href=\"paragraph.html\">paragraph</a>\nwith <em>formatting</em>.</p></blockquote>")
    }
    
    func testBlockQuoteWithArrows() {
        let (p, _) = blockQuote("> This is\n> a paragraph\n> with words.\n\n")
        XCTAssertEqual(p.map(html)!, "<blockquote><p>This is\na paragraph\nwith words.</p></blockquote>")
    }
    
    func testBlockQuoteWithSpacesWithArrows() {
        let (p, _) = blockQuote("> This is\n> a paragraph\n> with words.\n  \t\n")
        XCTAssertEqual(p.map(html)!, "<blockquote><p>This is\na paragraph\nwith words.</p></blockquote>")
    }
    
    func testBlockQuoteWithSpanFormattingWithArrows() {
        let (p, _) = blockQuote("> This is\n> a [paragraph](paragraph.html)\n> with *formatting*.\n\n")
        XCTAssertEqual(p.map(html)!, "<blockquote><p>This is\na <a href=\"paragraph.html\">paragraph</a>\nwith <em>formatting</em>.</p></blockquote>")
    }
    
}

class ListTests: XCTestCase {
    func testList() {
        let (p, _) = list("* This is\n* a list\n* with *formatting*.\n\n")
        XCTAssertEqual(p.map(html)!, "<ul><li>This is</li><li>a list</li><li>with <em>formatting</em>.</li></ul>")
    }
}

class CodeBlockTests: XCTestCase {
    func testCodeBlock() {
        let (c, _) = codeBlock("```\nThis is\nsome code\n   with things.\n```")
        XCTAssertEqual(c.map(html)!, "<code>This is\nsome code\n   with things.</code>")
    }
}

class BlockElementsTests: XCTest {
    func testPriorities() {
        let (h1, _) = header("# Title\n\n## Subtitle")
        // It would be wrong to put "## Subtitle" into a paragrpah
        XCTAssertEqual(html(h1!), "<h1>Title</h1>\n<h2>Subtitle</h2>")
    }
}
