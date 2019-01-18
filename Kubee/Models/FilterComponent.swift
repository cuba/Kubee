//
//  FilterComponent.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2017-04-07.
//  Copyright © 2017 Studio MDE Inc. All rights reserved.
//

import Foundation

enum FilterComponentType {
    case selector
    case text
    
    func transform(_ string: String, with settings: FilterSettings) -> String {
        switch self {
        case .selector: return settings.transform(string)
        case .text: return string
            
        }
    }
}

struct FilterComponent {
    fileprivate(set) var range: Range<String.Index>
    fileprivate(set) var value: String
    fileprivate(set) var type: FilterComponentType
    
    var settings = FilterSettings()
    
    init(range: Range<String.Index>, value: String, type: FilterComponentType) {
        self.type = type;
        self.range = range
        self.value = value
    }
    
    func transform(_ string: String) -> String {
        return type.transform(string, with: settings)
    }
}

extension FilterComponent: Equatable {
    public static func ==(lhs: FilterComponent, rhs: FilterComponent) -> Bool {
        return lhs.value == rhs.value && lhs.range == rhs.range && lhs.type == rhs.type
    }
}
