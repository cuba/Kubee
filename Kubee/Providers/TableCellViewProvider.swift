//
//  TableCellViewProvider.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2017-04-08.
//  Copyright © 2017 Studio MDE Inc. All rights reserved.
//

import Foundation
import Cocoa

enum TableCellViewProvider: String {
    case file       = "FileTableCellView"
    case selector   = "SelectorTableCellView"
    
    var identifier: String {
        switch self {
        case .file      : return "file"
        case .selector  : return "selector"
        }
    }
    
    var nib: NSNib {
        return NSNib(nibNamed: rawValue, bundle: Bundle.main)!
    }
    
    func registerCell(for tableView: NSTableView) {
        tableView.register(nib, forIdentifier: identifier)
    }
    
    func dequeCell(for tableView: NSTableView, owner: Any) -> NSView  {
        let cell = tableView.make(withIdentifier: identifier, owner: owner)
        return cell!
    }
}
