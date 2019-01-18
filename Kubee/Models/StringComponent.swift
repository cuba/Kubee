//
//  RenameComponent.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2017-04-07.
//  Copyright © 2017 Studio MDE Inc. All rights reserved.
//

import Foundation

struct RenameComponent {
    private(set) var filterComponent: FilterComponent
    private(set) var range: Range<String.Index>
    private(set) var value: String
    private(set) var renamedValue: String
    
    init(range: Range<String.Index>, value: String, filterComponent: FilterComponent) {
        self.renamedValue = filterComponent.transform(value)
        self.filterComponent = filterComponent
        self.range = range
        self.value = value
    }
}

extension RenameComponent: Equatable {
    public static func ==(lhs: RenameComponent, rhs: RenameComponent) -> Bool {
        return lhs.value == rhs.value && lhs.range == rhs.range && lhs.filterComponent == rhs.filterComponent
    }
}
