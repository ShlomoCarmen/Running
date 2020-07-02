//
//  User.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 01/07/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import Foundation

struct User {
    
    var gender: String
    var age: Int
    var height: Int
    var weight: Int
    
    init?(values: [String:Any]) {
        if let gender = values["gender"] as? String {
            self.gender = gender
        } else { return nil }
        
        if let age = values["age"] as? Int {
            self.age = age
        } else { return nil }
        
        if let height = values["height"] as? Int {
            self.height = height
        } else { return nil }
        
        if let weight = values["weight"] as? Int {
            self.weight = weight
        } else { return nil }
        
    }
    
    var values: [String:Any] {
        var values: [String:Any] = [:]
        values["gender"] = self.gender
        values["age"] = self.age
        values["height"] = self.height
        values["weight"] = self.weight
 
        return values
    }
}
