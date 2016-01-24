//
//  SwiftDown.swift
//  SwiftDown
//
//  Created by Fabian Canas on 1/18/16.
//  Copyright © 2016 Fabián Cañas. All rights reserved.
//

import Foundation

struct Header {
    let level :Int
    let content :[SpanElement]
}

struct Line {
    let content :[SpanElement]
}

enum ListType {
    case Ordered
    case Unordered
}

enum Either<TA, TB> {
    case A(TA)
    case B(TB)
}

indirect enum BlockElement {
    case Paragraph([Line])
    case Header(level :Int, content: Line)
    case Blockquote([Line])
    case List(ListType, [Either<BlockElement, SpanElement>])
    case CodeBlock(String)
    case HorizontalRule
}

enum SpanElement {
    case Text(content: String)
    case Link(text: String, url: NSURL)
    case Emphasis(content: String)
    case Code(content: String)
    case Image(altText: String, url: NSURL, title: String?)
}

func html(elements :[BlockElement]) -> String {
    return elements.map(html).joinWithSeparator("\n")
}

func html(element :BlockElement) -> String {
    switch element {
    case .Paragraph(let lines):
        return lines.map(html).joinWithSeparator("\n")
    case .Header(let level, let content):
        return "<h\(level)>" + html(content) + "</h\(level)>"
    case .HorizontalRule:
        return "<hr />"
    default:
        return ""
    }
}

func header(input :String) -> (BlockElement?, String) {
    let (captures, advance) = input.capture(/"(#{1,6})\\s(.*)"/)
    guard let l = captures.first where l.count == 2 else {
        return (nil, input)
    }
    let (headerContent, _) = line(l[1])
    return (BlockElement.Header(level: l[0].characters.count, content: headerContent), input.substringFromIndex(input.startIndex.advancedBy(advance)))
}

func horizontalRule(input :String) -> (BlockElement?, String) {
    let (captures, advance) = input.capture(/"^([-\\*_]\\s?){3,}$"/)
    guard captures.first != nil else {
        return (nil, input)
    }
    return (BlockElement.HorizontalRule, input.substringFromIndex(input.startIndex.advancedBy(advance)))
}
