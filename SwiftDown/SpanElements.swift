//
//  SpanElements.swift
//  SwiftDown
//
//  Created by Fabian Canas on 1/18/16.
//  Copyright © 2016 Fabián Cañas. All rights reserved.
//

import Foundation

/// HTML Generation

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

/// Line Parsing

let elementParsers = [link, emphasis, code, image]

func line(input :String) -> (Line, String) {
    let (captures, advance) = input.capture(/"^(.*)$"/)
    guard let l = captures.first where l.count == 1 else {
        return (Line(content:[]), input)
    }
    var elements = Array<SpanElement>()
    var remainder = l.first!
    var currentText :String? = nil
    while remainder.characters.count > 0 {
        for matcher in elementParsers {
            let (e, s) = matcher(remainder)
            if let e = e {
                remainder = s
                if let t = currentText {
                    elements.append(SpanElement.Text(content: t))
                    currentText = nil
                }
                elements.append(e)
                break
            }
        }
        if currentText == nil {
            currentText = ""
        }
        currentText?.append(remainder.characters.first!)
        remainder = remainder.substringFromIndex(remainder.startIndex.advancedBy(1))
    }
    if let t = currentText {
        elements.append(SpanElement.Text(content: t))
        currentText = nil
    }
    return (Line(content:elements), input.substringFromIndex(input.startIndex.advancedBy(advance)))
}

/// Span Element Match

func text(input :String) -> (SpanElement?, String) {
    let (captures, advance) = input.capture(/"^."/)
    guard let l = captures.first where l.count == 1 else {
        return (nil, input)
    }
    return (SpanElement.Emphasis(content: l[0]), input.substringFromIndex(input.startIndex.advancedBy(advance)))
}

func link(input :String) -> (SpanElement?, String) {
    let (captures, advance) = input.capture(/"^\\[(.*)\\]\\((.*)\\)"/)
    guard let l = captures.first where l.count == 2 else {
        return (nil, input)
    }
    return (NSURL(string: l[1]).map( { SpanElement.Link(text: l[0], url: $0) } ), input.substringFromIndex(input.startIndex.advancedBy(advance)))
}

func emphasis(input :String) -> (SpanElement?, String) {
    let (captures, advance) = input.capture(/"^\\*(.*)\\*"/)
    guard let l = captures.first where l.count == 1 else {
        return (nil, input)
    }
    return (SpanElement.Emphasis(content: l[0]), input.substringFromIndex(input.startIndex.advancedBy(advance)))
}

func code(input :String) -> (SpanElement?, String) {
    let (captures, advance) = input.capture(/"^`(.*)`"/)
    guard let l = captures.first where l.count == 1 else {
        return (nil, input)
    }
    return (SpanElement.Code(content: l[0]), input.substringFromIndex(input.startIndex.advancedBy(advance)))
}

func image(input :String) -> (SpanElement?, String) {
    let (captures, advance) = input.capture(/"^!\\[(.+)\\]\\((\\S+)(?:\\s\"(.+)\")?\\)"/)
    guard let l = captures.first where l.count == 2 || l.count == 3 else {
        return (nil, input)
    }
    var title :String? = nil
    if l.count>2 {
        title = l[2] == "" ? nil : l[2]
    }
    return (NSURL(string: l[1]).map( { SpanElement.Image(altText: l[0], url: $0, title: title) } ), input.substringFromIndex(input.startIndex.advancedBy(advance)))
}

