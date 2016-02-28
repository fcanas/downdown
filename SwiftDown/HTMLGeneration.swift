//
//  HTMLGeneration.swift
//  SwiftDown
//
//  Created by Fabian Canas on 1/27/16.
//  Copyright © 2016 Fabián Cañas. All rights reserved.
//

import Foundation

/// Markdown to HTML

public func markdown(input :String) -> String {
    return html(blocks(input))
}

/// Block Elements

func html_(element :Either<BlockElement, Line>) -> String {
    switch element {
    case .A(let block):
        return html(block)
    case .B(let line):
        return html(line)
    }
}

func html(elements :[BlockElement]) -> String {
    return elements.map(html).joinWithSeparator("\n")
}

func html(element :BlockElement) -> String {
    switch element {
    case .Paragraph(let lines):
        return "<p>" + lines.map(html).joinWithSeparator("\n") + "</p>"
    case .Header(let level, let content):
        return "<h\(level)>" + html(content) + "</h\(level)>"
    case .BlockQuote(let blockElement):
        return "<blockquote>\(html(blockElement))</blockquote>"
    case .List(let type, let items):
        return "<\(type.htmlTag())>" + items.map(html_).map({ "<li>\($0)</li>" }).joinWithSeparator("") + "</\(type.htmlTag())>"
    case .CodeBlock(let content):
        return "<pre><code>\(content)</code></pre>"
    case .HorizontalRule:
        return "<hr />"
    }
}

/// Span Elements

func html(line :Line) -> String {
    return line.content.map(html).joinWithSeparator("")
}

func html(element :SpanElement) -> String {
    switch element {
    case .Link(let text, let url):
        return "<a href=\"\(url.absoluteString)\">\(text)</a>"
    case .Emphasis(let content):
        return "<em>\(content)</em>"
    case .Code(let content):
        return "<code>\(content)</code>"
    case .Image(let altText, let url, let title):
        return "<img alt=\"\(altText)\" src=\"\(url)\"\(title != nil ? " title=\"" + title! + "\"" : "")>"
    case .Text(let content):
        return content
    }
}

