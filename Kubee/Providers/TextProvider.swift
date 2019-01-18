//
//  TextProvider.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2017-04-07.
//  Copyright © 2017 Studio MDE Inc. All rights reserved.
//

import Foundation

enum Text {
    enum Title: String {
        case parsingError = "Title.ParsingError"
        case renamingError = "Title.RenamingError"
        
        var key: String {
            return rawValue
        }
        
        var localized: String {
            return key.localized()
        }
    }
    
    enum Label: String {
        case renameFiles = "Label.RenameFiles"
        case renameSelectedFiles = "Label.RenameSelectedFiles"
        
        var key: String {
            return rawValue
        }
        
        var localized: String {
            return key.localized()
        }
    }

    enum TextField {
        case filter
        case replace
        
        var labelKey: String {
            switch self {
            case .filter: return "Label.Filter"
            case .replace: return "Label.Replace"
            }
        }
        
        var placeholderKey: String {
            switch self {
            case .filter: return "Placeholder.Filter"
            case .replace: return "Placeholder.Replace"
            }
        }
        
        var label: String {
            return labelKey.localized()
        }
        
        var placeholder: String {
            return placeholderKey.localized()
        }
    }
}
