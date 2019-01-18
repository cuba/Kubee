//
//  Filter.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2017-04-07.
//  Copyright © 2017 Studio MDE Inc. All rights reserved.
//

import Foundation

enum FilterError: Error {
    case ambiguousSelector(selector: String)
    
    var key: String {
        switch self {
        case .ambiguousSelector: return "FilterError.AmbiguousSelector"
        }
    }
    
    var params: [String: String] {
        switch self {
        case .ambiguousSelector(let selector): return ["selector": selector]
        }
    }
}

extension FilterError: LocalizedError {
    var errorDescription: String? {
        return key.localized(params: params)
    }
}

protocol ParsedString {
    var error: Error? { get }
    var components: [FilterComponent] { get }
    
    mutating func validate() -> Bool
}

struct Filter: ParsedString {
    fileprivate(set) var components: [FilterComponent] = []
    var error: Error?
    
    var componentStrings: [String] {
        return components.map({ $0.value })
    }
    
    var string: String {
        return componentStrings.joined()
    }
    
    init() {}
    
    init(components: [FilterComponent]) {
        self.components = components
    }
    
    func components(for type: FilterComponentType) -> [FilterComponent] {
        return components.filter({ $0.type == type})
    }
    
    mutating func append(_ component: FilterComponent) {
        components.append(component)
    }
    
    mutating func replace(_ component: FilterComponent) -> Bool {
        if let index = components.index(of: component) {
            components[index] = component
            return true
        } else {
            return false
        }
    }
    
    func index(of component: FilterComponent) -> Int? {
        return components.index(of: component)
    }
    
    mutating func merge(_ filter: Filter) -> Filter {
        for component in filter.components {
            if let index = components.index(of: component) {
                components[index].settings = component.settings
            }
        }
        
        return self
    }
    
    mutating func validate() -> Bool {
        for component in components(for: .selector) {
            guard checkUniqueness(of: component) else {
                error = FilterError.ambiguousSelector(selector: component.value)
                return false
            }
        }
        
        return true
    }
    
    func checkUniqueness(of component: FilterComponent) -> Bool {
        return components.index(where: {
            return $0.range != component.range && $0.value == component.value
        }) == nil
    }
    
    func checkPresence(of component: FilterComponent) -> Bool {
        
        for componentTwo in self.components(for: .selector) {
            if component.value == componentTwo.value {
                return true
            }
        }
        
        return false
    }
}

extension Filter: Equatable {
    public static func ==(lhs: Filter, rhs: Filter) -> Bool {
        return lhs.components == rhs.components
    }
}
