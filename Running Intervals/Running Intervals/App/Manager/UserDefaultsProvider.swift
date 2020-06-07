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
    }
    
    static private var provider: UserDefaultsProvider?
    
    private let defaults = UserDefaults.standard
    
    private init() {
        self.defaults.register(defaults: [
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
}
