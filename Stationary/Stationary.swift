//
//  Stationary.swift
//  SwiftDown
//
//  Created by Fabian Canas on 2/27/16.
//  Copyright © 2016 Fabián Cañas. All rights reserved.
//

import Foundation

let openToken = "{{ "
let closeToken = " }}"

enum TemplateItem {
    /**
     * A Static template item is ready to be rendered
     */
    case Static(content :String)
    /**
     * A Dynamic template item cannot be rendered. It holds the
     * key used to lookup a value when hydrated from a dictionary
     */
    case Dynamic(key :String)
}

/**
 * Finds `token` in `input` and returns ranges in `input`
 * corresponding the the range before the first occurence of
 * token, and the range after the first occurence of token.
 *
 * The `range` parameter indicates where `token` is searched for 
 * and are expressed relative to input.
 *
 * The output ranges are relative to input, but span within
 * the provided search `range` to `input`'s start and end. 
 */
func split(input :String, token :String, range: Range<String.Index>) -> (Range<String.Index>, Range<String.Index>) {
    guard let tokenRange = input.rangeOfString(token, options: NSStringCompareOptions(), range: range, locale: nil) else {
        return ( range.startIndex ..< range.endIndex , input.endIndex ..< input.endIndex )
    }
    
    let preRange = range.startIndex ..< tokenRange.startIndex
    let postRange = tokenRange.endIndex ..< range.endIndex
    return (preRange, postRange)
}

/**
 * Finds the first occurence of `token` in `input` and returns 
 * ranges in `input` corresponding the the range before the 
 * first occurence of token, and the range after the first 
 * occurence of token.
 */

func split(input :String, token :String) -> (Range<String.Index>, Range<String.Index>) {
    return split(input, token: token, range: input.startIndex ..< input.endIndex)
}

enum Template {
    /**
     * an .Incomplete template has an array of TemplateItem, one or more of
     * which is TemplateItem.Dyncamic
     */
    case Incomplete(Array<TemplateItem>)
    
    /**
     * a .Complete template has an array of TemplateItem.Static
     */
    case Complete(Array<TemplateItem>)
    
    init(templateString :String) {
        var items = Array<TemplateItem>()
        
        var candidateRange = templateString.startIndex ..< templateString.endIndex
        
        var hasDynamicItem = false
        
        while candidateRange.count > 0 {
            var itemRange :Range<String.Index>
            // Static
            (itemRange, candidateRange) = split(templateString, token: openToken, range: candidateRange)
            if itemRange.count > 0 {
                items.append(.Static(content: templateString.substringWithRange(itemRange)))
            }
            
            // Dynamic
            (itemRange, candidateRange) = split(templateString, token: closeToken, range: candidateRange)
            if itemRange.count > 0 {
                hasDynamicItem = true
                items.append(.Dynamic(key: templateString.substringWithRange(itemRange)))
            }
        }
        
        if hasDynamicItem {
            self = .Incomplete(items)
        } else {
            self = .Complete(items)
        }
    }
}

enum TemplateError : ErrorType {
    case RenderingAnIncompleteTemplate
    case CompleteTemplateContainsDynamicTemplateItem
}

extension Template {
    func hydrate(values :[String : String]) -> Template {
        
        let hydratedItems :Array<TemplateItem>
        
        // This little flag, and the potential for failure to maintain state
        // is because the type system doesn't capture an invariant we want to
        // maintain: a .Complete template has an array of TemplateItem.Static.
        // Maybe a better type design is in order?
        var hasDynamicItem :Bool = false
        
        switch self {
        case .Complete:
            return self
        case let .Incomplete(items):
            hydratedItems = items.map({ (item :TemplateItem) -> TemplateItem in
                switch item {
                case .Static:
                    return item
                case let .Dynamic(key):
                    if let value = values[key] {
                        return .Static(content: value)
                    } else {
                        hasDynamicItem = true
                        return item
                    }
                }
            })
        }
        
        if hasDynamicItem {
            return .Incomplete(hydratedItems)
        } else {
            return .Complete(hydratedItems)
        }
    }
    
    func render() throws -> String {
        switch self {
        case let .Complete(items):
            return try items.reduce(String(), combine: { (outputString, item) throws -> String in
                switch item {
                case .Dynamic:
                    throw TemplateError.CompleteTemplateContainsDynamicTemplateItem
                case let .Static(content):
                    return outputString + content
                }
            })
        case .Incomplete:
            throw TemplateError.RenderingAnIncompleteTemplate
        }
    }
}


