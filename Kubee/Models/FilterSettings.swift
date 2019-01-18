//
//  FilterSettings.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2017-04-07.
//  Copyright © 2017 Studio MDE Inc. All rights reserved.
//

import Foundation

enum TextTransformation: Int {
    case none = 0
    case capitalize
    case uppercase
    case lowercase
    
    func transform(_ string: String) -> String {
        switch self {
        case .none: return string
        case .capitalize: return string.capitalized
        case .uppercase: return string.uppercased()
        case .lowercase: return string.lowercased()
        }
    }
}

struct FilterSettings {
    var transformation: TextTransformation = .none
    var replace :String?
    var with :String?
    
    func transform(_ string: String) -> String {
        var string = string
        
        if let replace = self.replace, let with = self.with {
            string = string.replacingOccurrences(of: replace, with: with)
        }
        
        return transformation.transform(string)
    }
}
