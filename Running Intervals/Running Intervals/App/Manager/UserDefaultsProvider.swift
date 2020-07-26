//
//  UserDefaultsProvider.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 27/05/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import Foundation

class UserDefaultsProvider {
    
    private enum UserDefaultsKeys: String {
        case fastSongs = "FastSongs"
        case slowSongs = "SlowSongs"
        case appLanguages = "AppleLanguages"
        case user = "User"
        case goal = "Goal"
        case week = "Week"
        case training = "Training"
        case seenWalkThrough = "SeenWalkThrough"
    }
    
    static private var provider: UserDefaultsProvider?
    
    private let defaults = UserDefaults.standard
    
    private init() {
        self.defaults.register(defaults: [
            UserDefaultsKeys.seenWalkThrough.rawValue: false,
            UserDefaultsKeys.appLanguages.rawValue: ["he"]
            ]
        )
    }
    
    class var shared: UserDefaultsProvider {
        if self.provider == nil {
            self.provider = UserDefaultsProvider()
        }
        return self.provider!
    }
    
    var appLanguageCode: String {
        get {
            return (self.defaults.object(forKey: UserDefaultsKeys.appLanguages.rawValue) as! [String]).first!
        }
        set (languageCode) {
            self.defaults.set([languageCode], forKey: UserDefaultsKeys.appLanguages.rawValue)
            self.defaults.synchronize()
        }
    }
    
    var fastSongs: [String] {
        get {
            return self.defaults.array(forKey: UserDefaultsKeys.fastSongs.rawValue) as? [String] ?? []
        }
        set (mediaItems){
            self.defaults.set(mediaItems, forKey: UserDefaultsKeys.fastSongs.rawValue)
            self.defaults.synchronize()
        }
    }
    
    var slowSongs: [String] {
        get {
            return self.defaults.array(forKey: UserDefaultsKeys.slowSongs.rawValue) as? [String] ?? []
        }
        set (mediaItems){
            self.defaults.set(mediaItems, forKey: UserDefaultsKeys.slowSongs.rawValue)
            self.defaults.synchronize()
        }
    }
    
    var user: User? {
        get {
            guard let values = self.defaults.object(forKey: UserDefaultsKeys.user.rawValue) as? [String:Any] else { return nil }
            return User(values: values)
            
        }
        set (user){
            self.defaults.set(user?.values, forKey: UserDefaultsKeys.user.rawValue)
            self.defaults.synchronize()
        }
    }
    
    var goal: String? {
        get {
            return self.defaults.string(forKey: UserDefaultsKeys.goal.rawValue)
        }
        set (goal){
            self.defaults.set(goal, forKey: UserDefaultsKeys.goal.rawValue)
            self.defaults.synchronize()
        }
    }
    
    var week: Int {
        get {
            return self.defaults.integer(forKey: UserDefaultsKeys.week.rawValue)
        }
        set (week){
            self.defaults.set(week, forKey: UserDefaultsKeys.week.rawValue)
            self.defaults.synchronize()
        }
    }
    
    var training: Int {
        get {
            return self.defaults.integer(forKey: UserDefaultsKeys.training.rawValue)
        }
        set (training){
            self.defaults.set(training, forKey: UserDefaultsKeys.training.rawValue)
            self.defaults.synchronize()
        }
    }
    
    var seenWalkThrough: Bool {
        get {
            return self.defaults.bool(forKey: UserDefaultsKeys.seenWalkThrough.rawValue)
            
        }
        set (value){
            self.defaults.set(value, forKey: UserDefaultsKeys.seenWalkThrough.rawValue)
            self.defaults.synchronize()
        }
    }
    
}
