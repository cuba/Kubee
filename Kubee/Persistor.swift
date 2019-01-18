//
//  Persistor.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2017-04-15.
//  Copyright © 2017 Studio MDE Inc. All rights reserved.
//

import Foundation
import ObjectMapper

enum Persistance {
    case filter
    case replace
    case fileUrls
    
    var key: String {
        switch self {
        case .filter: return "filter"
        case .replace: return "replace"
        case .fileUrls: return "fileUrls"
        }
    }
}

class Persistor {
    static func pack<T: Mappable>(_ model: T, key: String) {
        let jsonString = model.toJSONString(prettyPrint: false)
        pack(jsonString, key: key)
    }
    
    static func pack<T: Mappable>(_ models: [T], key: String) {
        let jsonString = models.toJSONString(prettyPrint: false)
        pack(jsonString, key: key)
    }
    
    static func unpack<T: Mappable>(key: String) -> T? {
        if let jsonString = string(key) {
            return T(JSONString: jsonString)
        } else {
            return nil
        }
    }
    
    static func unpack<T: Mappable>(key: String) -> [T]? {
        if let jsonString = string(key) {
            return [T](JSONString: jsonString)
        } else {
            return nil
        }
    }
    
    static func pack(_ string: String?, key: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(string, forKey: key)
    }
    
    static func string(_ key: String) -> String? {
        let userDefaults = UserDefaults.standard
        return userDefaults.string(forKey: key)
    }
}
