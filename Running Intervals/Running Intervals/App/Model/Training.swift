//
//  Training.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 05/07/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import Foundation

struct Training {
    
    var goal: String
    var week: Int
    var training: Int
    var sessionId: String
    var descreption: String
    var timeForRun: Int
    var timeForWalk: Int
    var intervals: Int
    
    init?(values: [String:Any]) {
        if let goal = values["goal"] as? String {
            self.goal = goal
        } else { return nil }
        
        if let week = values["week"] as? Int {
            self.week = week
        } else { return nil }
        
        if let training = values["training"] as? Int {
            self.training = training
        } else { return nil }
        
        if let sessionId = values["sessionId"] as? String {
            self.sessionId = sessionId
        } else { return nil }
        
        if let descreption = values["descreption"] as? String {
            self.descreption = descreption
        } else { return nil }
        
        if let timeForRun = values["timeForRun"] as? Int {
            self.timeForRun = timeForRun
        } else { return nil }
        
        if let timeForWalk = values["timeForWalk"] as? Int {
            self.timeForWalk = timeForWalk
        } else { return nil }
        
        if let intervals = values["intervals"] as? Int {
            self.intervals = intervals
        } else { return nil }
        
    }
    
    var values: [String:Any] {
        var values: [String:Any] = [:]
        values["goal"] = self.goal
        values["week"] = self.week
        values["training"] = self.training
        values["sessionId"] = self.sessionId
        values["descreption"] = self.descreption
        values["timeForRun"] = self.timeForRun
        values["timeForWalk"] = self.timeForWalk
        values["intervals"] = self.intervals
 
        return values
    }
}
