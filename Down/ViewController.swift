//
//  ViewController.swift
//  Down
//
//  Created by Fabian Canas on 1/26/16.
//  Copyright © 2016 Fabián Cañas. All rights reserved.
//

import Cocoa
import SwiftDown

class ViewController: NSViewController, NSTextViewDelegate {

    @IBOutlet var editableText :NSTextView!
    @IBOutlet var outputView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }

    func textDidChange(notification: NSNotification) {
        if let textView = notification.object as? NSTextView {
            
            outputView.string = markdown(textView.string!)
        }
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

