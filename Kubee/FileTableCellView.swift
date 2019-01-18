//
//  FileTableCellView.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2015-06-13.
//  Copyright (c) 2015 Jacob Sikorski. All rights reserved.
//

import Cocoa

class FileTableCellView: NSTableCellView {
    @IBOutlet weak var icon: NSImageView!
    @IBOutlet weak var filename: NSTextField!
    @IBOutlet weak var preview: NSTextField!
    @IBOutlet weak var path: NSTextField!
    @IBOutlet weak var errorIndicator: ErrorIndicatorView!

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override func prepareForReuse() {
        //icon.image = nil;
        
    }
}
