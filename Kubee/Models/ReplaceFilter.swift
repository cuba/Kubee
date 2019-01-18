//
//  ReplaceFilter.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2017-04-08.
//  Copyright © 2017 Studio MDE Inc. All rights reserved.
//

import Foundation

enum ReplaceFilterError: Error {
    case selectorNotFound(selector: String)
    case empty
    
    var key: String {
        switch self {
        case .selectorNotFound: return "ReplaceFilterError.SelectorNotFound"
        case .empty: return "ReplaceFilterError.Empty"
        }
    }
    
    var params: [String: String] {
        switch self {
        case .selectorNotFound(let selector): return ["selector": selector]
        default: return [:]
        }
    }
}

extension ReplaceFilterError: LocalizedError {
    var errorDescription: String? {
        return key.localized(params: params)
    }
}

struct ReplaceFilter: ParsedString {
    fileprivate(set) var components: [FilterComponent] = []
    var error: Error?
    
    init() {}
    
    init(components: [FilterComponent]) {
        self.components = components
    }
    
    mutating func validate() -> Bool {
        guard components.count > 0 else {
            error = ReplaceFilterError.empty
            return false
        }
        
        for component in components(for: .selector) {
            guard let filter = FileRenameManager.shared.filter, filter.checkPresence(of: component) else {
                error = ReplaceFilterError.selectorNotFound(selector: component.value)
                return false
            }
        }
        
        return true
    }
    
    func validate(_ renameComponents: [RenameComponent]) -> Bool {
        let components = self.components(for: .selector)
        
        for component in components {
            guard renameComponents.index(where: { $0.filterComponent.value == component.value }) != nil else {
                return false
            }
        }
        
        return true
    }
    
    func generateName(with renameComponents: [RenameComponent]) -> String {
        let filterComponents = self.components
        
        let strings = filterComponents.map({ (component: FilterComponent) -> String in
            if let renameComponent = renameComponents.first(where: { $0.filterComponent.value == component.value }) {
                return renameComponent.renamedValue
            } else {
                return component.value
            }
        })
        
        return strings.joined()
    }
    
    private func components(for type: FilterComponentType) -> [FilterComponent] {
        return components.filter({ $0.type == type})
    }
}

extension ReplaceFilter: Equatable {
    public static func ==(lhs: ReplaceFilter, rhs: ReplaceFilter) -> Bool {
        return lhs.components == rhs.components
    }
}
