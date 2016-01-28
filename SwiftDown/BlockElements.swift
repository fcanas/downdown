//
//  BlockElements.swift
//  SwiftDown
//
//  Created by Fabian Canas on 1/27/16.
//  Copyright © 2016 Fabián Cañas. All rights reserved.
//

import Foundation

let blockParsers = [header, blockQuote, list, horizontalRule, codeBlock, paragraph]

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

func paragraph(input :String) -> (BlockElement?, String) {
    let (captures, _) = input.capture(RegEx("^(.+?)(\n\\s*\n)", options: [.DotMatchesLineSeparators, .AnchorsMatchLines]))
    guard let p = captures.first?.first, let total = captures.first else {
        return (nil, input)
    }
    let paragraph = lines(p)
    let advance = total.joinWithSeparator("")
    return (.Paragraph(paragraph), input.substringFromIndex(input.startIndex.advancedBy(advance.characters.count)))
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
    let (captures, advance) = input.capture(/"^([-\\*_]\\s??){3,}[\n]*"/)
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