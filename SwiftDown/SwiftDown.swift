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
    case Header(Line)
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
