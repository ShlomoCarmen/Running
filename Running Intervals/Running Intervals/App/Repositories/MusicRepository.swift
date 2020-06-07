//
//  MusicRepository.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 31/05/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import Foundation
import MediaPlayer

class MusicRepository {
    
    var runningMediaItems: [MPMediaItem] = []
    var walkingMediaItems: [MPMediaItem] = []
    
    private static var manager: MusicRepository?
    
    class var shared: MusicRepository {
        if self.manager == nil {
            self.manager = MusicRepository()
        }
        return self.manager!
    }
    
    private init() {
        self.dounloadMediaItems()
    }
    
    func updateMediaItems(persistantID: String, type: String) {
        if type == "running" {
            self.runningMediaItems.append(self.getSongItem(persistantID: persistantID)!)
        }
        else if type == "walking" {
            self.walkingMediaItems.append(self.getSongItem(persistantID: persistantID)!)
        }
    }
    
    func dounloadMediaItems() {
        for song in UserDefaultsProvider.shared.fastSongs {
            self.runningMediaItems.append(self.getSongItem(persistantID: song)!)
        }
        for song in UserDefaultsProvider.shared.slowSongs {
            self.walkingMediaItems.append(self.getSongItem(persistantID: song)!)
        }
    }
    
    func getSongItem(persistantID: String) -> MPMediaItem? {
        let noCloudPre = MPMediaPropertyPredicate(value: NSNumber(booleanLiteral: false), forProperty: MPMediaItemPropertyIsCloudItem)
        let songQuery = MPMediaQuery.songs()
        songQuery.addFilterPredicate(noCloudPre)
        songQuery.addFilterPredicate(MPMediaPropertyPredicate(value: persistantID, forProperty: MPMediaItemPropertyPersistentID, comparisonType: MPMediaPredicateComparison.equalTo))
        return songQuery.items?[0]
    }
    
    func deleteSong() {
        
    }
   
}
