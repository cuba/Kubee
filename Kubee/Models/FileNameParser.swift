//
//  FileNameParser.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2017-04-07.
//  Copyright © 2017 Studio MDE Inc. All rights reserved.
//

import Foundation

struct FileNameParser {
    enum ParsingError: Error {
        case staticComponentNotFound(staticComponent: String)
    }
    
    static func extractRenameComponents(from filename: String, with filter: Filter) throws -> [RenameComponent] {
        var renameComponents: [RenameComponent] = []
        var startIndex = filename.index(offsetBy: 0)
        var endIndex = filename.index(offsetBy: 0)
        
        var lastSelectorComponent: FilterComponent?
        var i = 0;
        
        for component in filter.components {
            var currentRange: Range<String.Index>?
            
            if component.type == .text {
                // Determine the range of the static text
                let searchRange = startIndex..<filename.endIndex;
                
                guard let range = filename.range(of: component.value, options: .literal, range: searchRange, locale: nil) else {
                    throw ParsingError.staticComponentNotFound(staticComponent: component.value)
                }
                
                endIndex = range.lowerBound
                
                // Determine if we found a valid range
                if startIndex < endIndex && lastSelectorComponent != nil {
                    //we found a selector. set the current range
                    currentRange = startIndex..<endIndex
                }
                
                startIndex = range.upperBound
                
            } else if component.type == .selector {
                lastSelectorComponent = component;
                
                if i == filter.components.count - 1 {
                    endIndex = filename.endIndex(offsetBy: 0)
                    currentRange = (startIndex ..< endIndex);
                }
            }
            
            if currentRange != nil {
                let value = filename.substring(with: currentRange!)
                let renameComponent = RenameComponent(range: currentRange!, value: value, filterComponent: lastSelectorComponent!)
                renameComponents.append(renameComponent)
            }
            
            i += 1;
        }
        
        return renameComponents;
    }
}

extension FileNameParser.ParsingError: LocalizedError {
    
    var key: String {
        switch self {
        case .staticComponentNotFound: return "FileNameParsingError.StaticComponentNotFound"
        }
    }
    
    var params: [String: String] {
        switch self {
        case .staticComponentNotFound(let staticComponent):
            return [
                "staticComponent": staticComponent
            ]
        }
    }
    
    var errorDescription: String? {
        return key.localized(params: params)
    }
}
