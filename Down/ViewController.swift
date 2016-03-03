//
//  ViewController.swift
//  Down
//
//  Created by Fabian Canas on 1/26/16.
//  Copyright © 2016 Fabián Cañas. All rights reserved.
//

import Cocoa
import SwiftDown
import WebKit
import Stationary

infix operator / { associativity left precedence 150 }

func / (lhs :String, rhs :String) -> String {
    return lhs + "\n" + rhs
}

let objectThingy = "item?"
let itemValue = "itemVluew"

class ProjectOutlineDataSource : NSObject, NSOutlineViewDataSource {
    
    func outlineView(outlineView: NSOutlineView,
        numberOfChildrenOfItem item: AnyObject?) -> Int {
        return 3
    }
    
    func outlineView(outlineView: NSOutlineView,
        child index: Int,
        ofItem item: AnyObject?) -> AnyObject {
            return objectThingy
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        return true
    }
    
    func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
        return itemValue
    }
}

class ViewController: NSViewController, NSTextViewDelegate, NSSplitViewDelegate {
    
    @IBOutlet var editableText :NSTextView!
    @IBOutlet var outputView: NSTextView!
    @IBOutlet weak var webView: WebView!
    @IBOutlet weak var navigatorSplitView: NSSplitView!
    
    let template = Template(templateString: "<html><body>{{ body }}</body></html>")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let codeFont = NSFont(name: "Inconsolata", size: 14) ?? NSFont(name: "Courier New", size: 14)
        
        editableText.font = codeFont
        outputView.font = codeFont
        
        editableText.string = "# Title" /
            "" /
            "## Subtitle" /
            "" /
            "* Things" /
            "* Objects" /
            "* Items" /
            "" /
            "-----" /
            "" /
            "*This* is a paragraph that" /
            "can be spread across *multiple*" /
            "lines  in the source file, but will" /
            "get consolidated into a single" /
            "paragraph. It can `also` contain" /
            "[links](http://www.fabiancanas.com)." /
            "" /
            "```" /
            "code does not get processed and *can* " /
            "exhibit markdown stuff without processing." /
        "```"
        
        processText(editableText.string!)
    }
    
    func textDidChange(notification: NSNotification) {
        if let text = (notification.object as? NSTextView)?.string {
            processText(text)
        }
    }
    
    func processText(text: String) {
        let htmlBody = markdown(text)
        let html = try? template.hydrate(["body":htmlBody]).render()
        outputView.string = html
        webView.mainFrame.loadHTMLString(html, baseURL: NSURL(string:"/"))
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func splitView(splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
        return subview === splitView.subviews.first
    }
    
    func splitView(splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return 100
    }
    
    override func validateMenuItem(menuItem: NSMenuItem) -> Bool {
        
        if menuItem.title == "Show Navigator" || menuItem.title == "Hide Navigator" {
            return true
        }
        
        return super.validateMenuItem(menuItem)
    }
    
    @IBAction func toggleNavigatorVisibility(sender :AnyObject) {
        
        let expandedWidth :CGFloat = 150
        let navigatorDividerIndex = 0
        let navigatorView = navigatorSplitView.subviews.first!
        let splitView = navigatorSplitView
        if splitView.isSubviewCollapsed(navigatorView) {
            splitView.setPosition(expandedWidth, ofDividerAtIndex: navigatorDividerIndex)
        } else {
            splitView.setPosition(0, ofDividerAtIndex: navigatorDividerIndex)
        }
    }
}

