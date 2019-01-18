//
//  File.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2017-04-07.
//  Copyright © 2017 Studio MDE Inc. All rights reserved.
//

import Foundation

struct File {
    private(set) var url: URL
    private(set) var filter = Filter()
    private(set) var renamedUrl: URL
    private(set) var replaceFilter = ReplaceFilter()
    private(set) var error: Error?
    private(set) var renameHistory: [URL] = []
    
    private var renameComponents: [RenameComponent] = []

    var isValid: Bool {
        return error == nil
    }
    
    var isChanged: Bool {
        return url != renamedUrl
    }
    
    var filename: String {
        return url.lastPathComponent
    }
    
    var directory: URL {
        return url.deletingLastPathComponent()
    }
    
    var preview: String {
        return renamedUrl.lastPathComponent
    }
    
    var path: String {
        return url.path
    }
    
    init(url: URL) {
        self.url = url
        self.renamedUrl = url
    }
    
    mutating func set(_ url: URL) {
        self.url = url
        generateRenameComponents()
    }
    
    mutating func apply(_ filter: Filter) {
        if self.filter != filter {
            self.filter = filter
            generateRenameComponents()
        }
    }
    
    mutating func apply(_ replaceFilter: ReplaceFilter) {
        if self.replaceFilter != replaceFilter {
            self.replaceFilter = replaceFilter
            generateNewURL()
        }
    }
    
    mutating func replace(_ component: FilterComponent) {
        if filter.replace(component) {
            generateRenameComponents()
        }
    }
    
    mutating func rename(undo: Bool = false) {
        do {
            let renamedUrl = undo ? renameHistory.popLast() ?? url : self.renamedUrl
            try FileManager.default.moveItem(at: url, to: renamedUrl)
            renameHistory.append(url)
            set(renamedUrl)
        } catch let error {
            self.error = error
        }
    }
    
    mutating func undo() throws {
        let oldUrl = renameHistory.popLast() ?? url
        
        do {
            try FileManager.default.moveItem(at: url, to: oldUrl)
            set(renamedUrl)
        } catch let error {
            self.error = error
            throw error
        }
    }
    
    private mutating func generateRenameComponents() {
        error = nil
        renameComponents = []
        
        do {
            renameComponents = try FileNameParser.extractRenameComponents(from: filename, with: filter)
        } catch let error {
            self.error = error
        }
        
        generateNewURL()
    }
    
    private mutating func generateNewURL() {
        if isValid, renameComponents.count > 0, replaceFilter.validate(renameComponents) {
            let newFilename = replaceFilter.generateName(with: renameComponents)
            self.renamedUrl = directory.appendingPathComponent(newFilename, isDirectory: false)
        } else {
            self.renamedUrl = url
        }
    }
}

extension File: Equatable {
    public static func ==(lhs: File, rhs: File) -> Bool {
        return lhs.url == rhs.url
    }
}
