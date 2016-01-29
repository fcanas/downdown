//
//  RegularExpressions.swift
//  SwiftDown
//
//  Created by Fabian Canas on 1/18/16.
//  Copyright © 2016 Fabián Cañas. All rights reserved.
//

import Foundation

/// Regex Utilities

prefix operator / { }
postfix operator / { }
postfix func / (pattern: String) -> () -> NSRegularExpression {
    return {
        RegEx(pattern)
    }
}

prefix func / (regexgen: () -> NSRegularExpression) -> NSRegularExpression {
    return regexgen()
}

func RegEx(pattern: String, options: NSRegularExpressionOptions = NSRegularExpressionOptions()) -> NSRegularExpression {
    return try! NSRegularExpression(pattern: pattern, options: options)
}

extension String {
    
    var fullRange :NSRange {
        get { return NSRange(location: 0, length: characters.count) }
    }
    
    func range(range :NSRange) -> Range<String.Index> {
        guard range.location != NSNotFound else {
            return Range(start: startIndex, end:startIndex)
        }
        let start = startIndex.advancedBy(range.location)
        return Range(start: start, end: start.advancedBy(range.length))
    }
    
    func capture(regex: NSRegularExpression, once: Bool = false) -> (groups: [[String]], advance: Int) {
        var advance = 0
        let groupFromStringArray = { (r :NSTextCheckingResult) -> [String] in
            var captureGroups = Array<String>()
            for var i = 1; i < r.numberOfRanges; i++ {
                captureGroups.append(self.substringWithRange(self.range(r.rangeAtIndex(i))))
            }
            advance = self.substringWithRange(self.range(r.range)).characters.count
            return captureGroups
        }
        
        if once {
            var captures = Array<Array<String>>()
            if let match = regex.firstMatchInString(self, options: NSMatchingOptions(), range: fullRange).map(groupFromStringArray) {
                captures.append(match)
            }
            return (captures, advance)
        }
        
        return (regex.matchesInString(self, options: NSMatchingOptions(), range: fullRange).map(groupFromStringArray), advance)
    }
    
    func replace(regex: NSRegularExpression, template: String) -> String {
        return regex.stringByReplacingMatchesInString(self, options: NSMatchingOptions(), range: fullRange, withTemplate: template)
    }
}
