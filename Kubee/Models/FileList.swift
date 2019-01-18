//
//  FileList.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2017-04-08.
//  Copyright © 2017 Studio MDE Inc. All rights reserved.
//

import Foundation
import Cocoa

struct FileList: Sequence {
    private(set) var files: [File] = []
    private(set) var filter: Filter = Filter()
    private(set) var replaceFilter: ReplaceFilter = ReplaceFilter()
    
    var count: Int {
        return files.count
    }

    var urls: [URL] {
        return files.map({ $0.url })
    }
    
    mutating func apply(_ filter: Filter) {
        self.filter = filter
        
        for i in 0..<files.count {
            files[i].apply(filter)
        }
    }
    
    mutating func apply(_ replaceFilter: ReplaceFilter) {
        self.replaceFilter = replaceFilter
        
        for i in 0..<files.count {
            files[i].apply(replaceFilter)
        }
    }
    
    mutating func replace(_ component: FilterComponent) -> Bool {
        let valid = filter.replace(component)
        
        for i in 0..<files.count {
            files[i].replace(component)
        }
        
        return valid
    }
    
    mutating func add(_ url: URL) -> Bool {
        var file = File(url: url)
        
        if (!files.contains(where: { $0 == file} )) {
            file.apply(filter)
            file.apply(replaceFilter)
            files.append(file)
            return true
        }
        
        return false
    }
    
    func file(at index: Int) -> File {
        return files[index]
    }
    
    func index(of url: URL) -> Int? {
        return files.index(where: { $0.url == url })
    }
    
    func filename(at index: Int) -> String {
        return file(at: index).filename
    }
    
    func directory(at index: Int) -> URL {
        return file(at: index).directory
    }
    
    mutating func remove(at index: Int) -> File {
        return files.remove(at: index)
    }
    
    mutating func set(url: URL, at index: Int) {
        files[index].set(url)
    }
    
    mutating func removeFiles(at indexes: IndexSet) -> [File] {
        var removed: [File] = []
        
        for index in indexes {
            removed.append(remove(at: index))
        }
        
        return removed
    }
    
    mutating func renameFile(at index: Int, undo: Bool = false) {
        files[index].rename(undo: undo)
    }
    
    mutating func removeAll() {
        files.removeAll()
    }
    
    func makeIterator() -> IndexingIterator<Array<File>> {
        return files.makeIterator()
    }
}
