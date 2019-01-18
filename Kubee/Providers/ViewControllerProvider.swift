//
//  ViewProvider.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2017-04-08.
//  Copyright © 2017 Studio MDE Inc. All rights reserved.
//

import Foundation
import Cocoa

enum ViewControllerProvider: String {
    case filterError = "FilterErrorView"
    
    var viewController: NSViewController  {
        switch self {
        case .filterError: return FilterErrorViewController(nibName: rawValue, bundle: Bundle.main)!
        }
    }
}
