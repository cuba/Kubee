//
//  FileRenameManager.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2015-07-13.
//  Copyright © 2015 Jacob Sikorski. All rights reserved.
//

import Cocoa

protocol FilterChangeDelegate {
    func filterHasChanged(_ filter: Filter?)
    func filterComponentChanged(_ filterComponent: FilterComponent)
}

protocol ReplaceFilterChangeDelegate {
    func replaceFilterHasChanged(for replaceFilter: ReplaceFilter?)
}

struct FileRenameManager {
    static var shared = FileRenameManager()
    
    private var filterChangeDelegates: [FilterChangeDelegate] = []
    private var replaceFilterChangeDelegates: [ReplaceFilterChangeDelegate] = []
    
    private(set) var filter: Filter?
    private(set) var replaceFilter: ReplaceFilter?
    
    mutating func set(_ filter: Filter) {
        var filter = filter
        
        if filter.validate() {
            var filter = filter
            
            if let previousFilter = self.filter {
                self.filter = filter.merge(previousFilter)
                
                // Notify the delegates only if something has changed
                if previousFilter != filter {
                    notifyFilterChangeDelegates()
                }
            } else {
                self.filter = filter
                notifyFilterChangeDelegates()
            }
        }
    }
    
    mutating func set(_ replaceFilter: ReplaceFilter) {
        var replaceFilter = replaceFilter
        
        if replaceFilter.validate() {
            if let previousReplaceFilter = self.replaceFilter {
                self.replaceFilter = replaceFilter
                
                // notify the delegates only if something changed
                if previousReplaceFilter != replaceFilter {
                    notifyReplaceFilterChangeDelegates()
                }
            } else {
                self.replaceFilter = replaceFilter
                notifyReplaceFilterChangeDelegates()
            }
        }
    }
    
    mutating func register(filterChangeDelegate: FilterChangeDelegate) {
        filterChangeDelegates.append(filterChangeDelegate)
        
        if let filter = self.filter {
            filterChangeDelegate.filterHasChanged(filter)
        }
    }
    
    mutating func register(replaceFilterChangeDelegate: ReplaceFilterChangeDelegate) {
        replaceFilterChangeDelegates.append(replaceFilterChangeDelegate)
        
        if let filter = self.replaceFilter {
            replaceFilterChangeDelegate.replaceFilterHasChanged(for: filter)
        }
    }
    
    mutating func updateFilterComponent(_ component: FilterComponent) {
        let _ = filter?.replace(component)
        
        for delegate in filterChangeDelegates {
            delegate.filterComponentChanged(component)
        }
    }
    
    func notifyFilterChangeDelegates() {
        for delegate in filterChangeDelegates {
            delegate.filterHasChanged(filter)
        }
    }
    
    func notifyReplaceFilterChangeDelegates() {
        for delegate in replaceFilterChangeDelegates {
            delegate.replaceFilterHasChanged(for: replaceFilter)
        }
    }
}
