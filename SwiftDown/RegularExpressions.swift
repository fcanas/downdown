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
    
    func capture(regex: NSRegularExpression) -> (groups: [[String]], advance: Int) {
        var advance = 0
        return (regex.matchesInString(self, options: NSMatchingOptions(), range: fullRange).map { (r :NSTextCheckingResult) -> [String] in
            var captureGroups = Array<String>()
            for var i = 1; i < r.numberOfRanges; i++ {
                captureGroups.append(substringWithRange(range(r.rangeAtIndex(i))))
            }
            advance = substringWithRange(range(r.range)).characters.count
            return captureGroups
        }, advance)
    }
}
