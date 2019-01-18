//
//  FilterErrorViewController.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2015-07-11.
//  Copyright © 2015 Jacob Sikorski. All rights reserved.
//

import Cocoa

class FilterErrorViewController: NSViewController {
    weak var titleTextField: NSTextField!
    weak var messageTextField: NSTextField!
    
    var errorTitle: String!
    var errorMessage: String!
    
    override func loadView() {
        var objects = NSArray()
        Bundle.main.loadNibNamed(self.nibName!, owner: self, topLevelObjects: &objects)
        
        for object in objects {
            if let view = object as? FilterErrorView {
                self.titleTextField = view.titleTextField
                self.messageTextField = view.messageTextField
                self.view = view
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        titleTextField.stringValue = self.errorTitle
        messageTextField.stringValue = self.errorMessage
    }
}
