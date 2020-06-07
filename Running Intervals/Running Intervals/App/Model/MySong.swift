//
//  MySong.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 27/05/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import Foundation
import MediaPlayer

class MySong {
    
    var mediaItem: MPMediaItem
    var selectedSong: Bool
    
    init(mediaItem: MPMediaItem, selectedSong: Bool){
        self.mediaItem = mediaItem
        self.selectedSong = selectedSong
    }
}
