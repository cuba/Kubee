//
//  SelectorsViewController.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2017-04-08.
//  Copyright © 2017 Studio MDE Inc. All rights reserved.
//

import Foundation

import Cocoa

class SelectorsViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    fileprivate var filter: Filter?
    
    var selectorComponents: [FilterComponent] {
        return filter?.components(for: .selector) ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Register Cells
        TableCellViewProvider.selector.registerCell(for: tableView)
        
        // Register delegates
        FileRenameManager.shared.register(filterChangeDelegate: self)
    }
}

//MARK: NSTableViewDataSource

extension SelectorsViewController: NSTableViewDataSource {
    func numberOfSectionsInTableView(_ tableView: NSTableView) -> Int {
        return 1
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return selectorComponents.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = TableCellViewProvider.selector.dequeCell(for: self.tableView, owner: self) as! SelectorTableCellView
        return configureCell(cell, row: row)
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 140
    }
    
    func configureCell(_ cell: SelectorTableCellView, row: Int) -> SelectorTableCellView {
        let selectorComponent = selectorComponents[row]
        cell.filterComponent = selectorComponent
        return cell
    }
}

//MARK: NSTableViewDelegate

extension SelectorsViewController: NSTableViewDelegate {
    
}

extension SelectorsViewController: FilterChangeDelegate {
    func filterHasChanged(_ filter: Filter?) {
        if filter != nil && self.filter != filter {
            self.filter = filter
            tableView.reloadData()
        }
    }
    
    func filterComponentChanged(_ filterComponent: FilterComponent) {
        // Do nothing
    }
}
