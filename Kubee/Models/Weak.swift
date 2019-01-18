//
//  Weak.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2017-04-08.
//  Copyright © 2017 Studio MDE Inc. All rights reserved.
//

import Foundation
struct Weak<T: AnyObject> {
    weak var value : T?
    
    init (value: T) {
        self.value = value
    }
    
    func get() -> T? {
        return value
    }
}
