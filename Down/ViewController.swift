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

class ViewController: NSViewController, NSTextViewDelegate {
    
    @IBOutlet var editableText :NSTextView!
    @IBOutlet var outputView: NSTextView!
    @IBOutlet weak var webView: WebView!
    
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
}

