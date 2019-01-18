//
//  Bundle+Extensions.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2017-04-07.
//  Copyright © 2017 Studio MDE Inc. All rights reserved.
//

import Foundation

extension Bundle {
    var kubee: Bundle {
        return Bundle(identifier: "com.kuba.Kubee")!
    }
    
    var version: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
