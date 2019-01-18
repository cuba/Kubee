//
//  ErrorIndicatorView.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2015-07-12.
//  Copyright © 2015 Jacob Sikorski. All rights reserved.
//

import Cocoa
protocol ErrorIndicatorMouseOverDelegate {
    func errorIndicatorMouseEntered(_ errorIndicatorView :ErrorIndicatorView)
    func errorIndicatorMouseExited(_ errorIndicatorView :ErrorIndicatorView)
}

class ErrorIndicatorView: NSImageView {
    fileprivate var trackingRectTag :NSTrackingRectTag?
    
    var mouseOverDelegate: ErrorIndicatorMouseOverDelegate?
    var title: String?
    var message: String?
    
    override func viewWillMove(toWindow newWindow: NSWindow?) {
        super.viewWillMove(toWindow: newWindow)
        
        trackingRectTag = self.addTrackingRect(self.bounds, owner: self, userData: nil, assumeInside: true)
    }
    
    override func mouseEntered(with theEvent: NSEvent) {
        super.mouseEntered(with: theEvent)
        
        if title != nil && message != nil {
            mouseOverDelegate?.errorIndicatorMouseEntered(self)
        }
    }
    
    override func mouseExited(with theEvent: NSEvent) {
        super.mouseExited(with: theEvent)
        mouseOverDelegate?.errorIndicatorMouseExited(self)
    }
}
