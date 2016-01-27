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

extension ListType {
    func htmlTag() -> String {
        switch self {
        case .Ordered:
            return "ol"
        case .Unordered:
            return "ul"
        }
    }
}

enum Either<TA, TB> {
    case A(TA)
    case B(TB)
}

indirect enum BlockElement {
    case Paragraph([Line])
    case Header(level :Int, content: Line)
    case BlockQuote(BlockElement)
    case List(ListType, [Either<BlockElement, Line>])
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

let blockParsers = [header, blockQuote, list, horizontalRule, codeBlock, paragraph]

public func markdown(input :String) -> String {
    return html(blocks(input))
}

func blocks(input :String) -> [BlockElement] {
    var text = input
    var output = Array<BlockElement>()
    repeat {
        let currentText = text
        for blockParser in blockParsers {
            let (b, t) = blockParser(text)
            if let b = b {
                output.append(b)
                text = t
                break
            }
        }
        if text == currentText {
            text = currentText.substringFromIndex(input.startIndex.advancedBy(1))
        }
    } while text.characters.count > 0
    return output
}

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
        return "<code>\(content)</code>"
    case .HorizontalRule:
        return "<hr />"
    }
}

func paragraph(input :String) -> (BlockElement?, String) {
    let (captures, advance) = input.capture(RegEx("^(.*?)\n\\s*\n", options: [.DotMatchesLineSeparators, .AnchorsMatchLines]))
    guard captures.count > 0 else {
        return (nil, input)
    }
    let l = captures.first!.flatMap(lines)
    return (.Paragraph(l), input.substringFromIndex(input.startIndex.advancedBy(advance)))
}

func header(input :String) -> (BlockElement?, String) {
    let (captures, advance) = input.capture(/"^(#{1,6})\\s(.*)\n*"/)
    guard let l = captures.first where l.count == 2 else {
        return (nil, input)
    }
    let (headerContent, _) = line(l[1])
    return (BlockElement.Header(level: l[0].characters.count, content: headerContent), input.substringFromIndex(input.startIndex.advancedBy(advance)))
}

func blockQuote(input :String) -> (BlockElement?, String) {
    let (captures, advance) = input.capture(RegEx("^> (.*?)\n\\s*\n", options: [.DotMatchesLineSeparators, .AnchorsMatchLines]))
    guard captures.count > 0 else {
        return (nil, input)
    }
    let strippedBrackets = captures.first!.first!.replace(RegEx("^ *> ?", options: [.AnchorsMatchLines]), template: "")
    let l = lines(strippedBrackets)
    return (.BlockQuote(.Paragraph(l)), input.substringFromIndex(input.startIndex.advancedBy(advance)))
}

func list(input :String) -> (BlockElement?, String) {
    let (captures, advance) = input.capture(RegEx("^\\* (.*?)\n\\s*\n", options: [.DotMatchesLineSeparators, .AnchorsMatchLines]))
    guard captures.count > 0 else {
        return (nil, input)
    }
    let strippedBullets = captures.first!.first!.replace(RegEx("^ *\\* ?", options: [.AnchorsMatchLines]), template: "")
    let listItems = lines(strippedBullets).map({ return Either<BlockElement, Line>.B($0) })
    return (.List(.Unordered, listItems), input.substringFromIndex(input.startIndex.advancedBy(advance)))
}

func horizontalRule(input :String) -> (BlockElement?, String) {
    let (captures, advance) = input.capture(/"^([-\\*_]\\s?){3,}$"/)
    guard captures.first != nil else {
        return (nil, input)
    }
    return (BlockElement.HorizontalRule, input.substringFromIndex(input.startIndex.advancedBy(advance)))
}

func codeBlock(input :String) -> (BlockElement?, String) {
    let (captures, advance) = input.capture(RegEx("^```\n(.*?)\n```", options: [.DotMatchesLineSeparators]))
    guard let code = captures.first else {
        return (nil, input)
    }
    return (BlockElement.CodeBlock(code.first!), input.substringFromIndex(input.startIndex.advancedBy(advance)))
}
