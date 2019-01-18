//
//  Selector.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2017-04-08.
//  Copyright © 2017 Studio MDE Inc. All rights reserved.
//

import Foundation

enum SelectorType {
    case staticText
    case selector
    case enumerator
}

protocol Selector {
    func transform(_ string: String, atRange: Range<String.Index>)
}

struct StaticTextSelector {
    var transformation: TextTransformation = .none
    var value: String
    
    init(value: String) {
        self.value = value
    }
    
    func transform(_ string: String, atRange: Range<String.Index>) {
        
    }
}
