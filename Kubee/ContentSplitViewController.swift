//
//  ContentSplitViewController.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2015-06-14.
//  Copyright (c) 2015 Jacob Sikorski. All rights reserved.
//

import Cocoa

class ContentSplitViewController: NSSplitViewController {
    fileprivate(set) var fileListViewController: FileListViewController!
    fileprivate(set) var renameControlerViewController: RenameViewController!
    var filterChangeDelegate: FilterChangeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let splitViewItems: [NSSplitViewItem] = self.splitViewItems as [NSSplitViewItem]
        
        for splitViewItem: NSSplitViewItem in splitViewItems {
            if let viewController = splitViewItem.viewController as? FileListViewController {
                fileListViewController = viewController
            } else if let viewController = splitViewItem.viewController as? RenameViewController {
                renameControlerViewController = viewController
            }
        }

    }
}
