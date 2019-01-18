//
//  MainWindowController.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2015-06-13.
//  Copyright (c) 2015 Jacob Sikorski. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        if menuItem.action == #selector(newDocument) {
            return true
        }
        
        return false
    }
    
    func newDocument(_ sender: AnyObject){
        window?.makeKeyAndOrderFront(self);
    }
}
