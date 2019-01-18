//
//  SourceListSplitViewController.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2015-06-14.
//  Copyright (c) 2015 Jacob Sikorski. All rights reserved.
//

import Cocoa

class SourceListSplitViewController: NSSplitViewController {
    @IBOutlet weak var selectorsSplitViewItem: NSSplitViewItem!
    @IBOutlet weak var contentSplitViewItem: NSSplitViewItem!
    
    private(set) var contentSplitViewController: ContentSplitViewController?
    private(set) var selectorsViewController: SelectorsViewController?
    var filterChangeDelegate: FilterChangeDelegate?
    var selectorsChangeDelegate: FilterChangeDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        contentSplitViewController = contentSplitViewItem.viewController as? ContentSplitViewController
        selectorsViewController = selectorsSplitViewItem.viewController as? SelectorsViewController
    }
}
