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

class ViewController: NSViewController, NSTextViewDelegate {

    @IBOutlet var editableText :NSTextView!
    @IBOutlet var outputView: NSTextView!
    @IBOutlet weak var webView: WebView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        editableText.string = "# Title\n\n" +
        "## Subtitle\n\n" +
        "* Things\n" +
        "* Objects\n" +
        "* Items\n\n" +
        "*This* is a paragraph that\n" +
        "can be spread across *multiple*\n" +
        "lines  in the source file, but will\n" +
        "get consolidated into a single\n" +
        "paragraph. It can `also` contain\n" +
        "[links](http://www.fabiancanas.com).\n\n" +
        "```\n" +
        "code does not get processed and *can* \n" +
        "exhibit markdown stuff without processing.\n" +
        "```"
    }

    func textDidChange(notification: NSNotification) {
        if let textView = notification.object as? NSTextView {
            let html = markdown(textView.string!)
            outputView.string = html
            webView.mainFrame.loadHTMLString(html, baseURL: NSURL(string:"/"))
        }
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

