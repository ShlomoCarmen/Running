//
//  SelectMusicViewController.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 26/05/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer

class SelectMusicViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let allMediaItems = MPMediaQuery.songs().items

    var fastSongs: [MPMediaItem] = []
    var slowSongs: [MPMediaItem] = []
    
    var newFastSongs: [MPMediaItem] = []
    var newSlowSongs: [MPMediaItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.fastSongs = MusicRepository.shared.runningMediaItems
        self.slowSongs = MusicRepository.shared.walkingMediaItems
        
        self.setText()
    }
    
    func setText() {
        self.titleLabel.text = Strings.selectMusic
        self.backButton.setTitle(Strings.back, for: .normal)
        self.doneButton.setTitle(Strings.save, for: .normal)
    }

    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time/60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        let minutesString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let secondsString = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        return "\(minutesString):\(secondsString)"
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.saveFastSongs()
        self.saveSlowSongs()
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveFastSongs() {
        for song in newFastSongs {
            let mediaItemPersistentID = String(song.persistentID)
            UserDefaultsProvider.shared.fastSongs.append(mediaItemPersistentID)
            MusicRepository.shared.updateMediaItems(persistantID: String(song.persistentID), type: "running")
        }
    }
    
    func saveSlowSongs() {
        for song in newSlowSongs {
            let mediaItemPersistentID = String(song.persistentID)
            UserDefaultsProvider.shared.slowSongs.append(mediaItemPersistentID)
            MusicRepository.shared.updateMediaItems(persistantID: String(song.persistentID), type: "walking")
        }
    }
    
    @objc func selectRunningSong(_ sender: UIButton) {
        guard let mediaItem = self.allMediaItems?[sender.tag] else { return }
        self.newFastSongs.append(mediaItem)
        self.fastSongs.append(mediaItem)
        self.tableView.reloadData()
        
    }
    
    @objc func selectWalkingSong(_ sender: UIButton) {
        guard let mediaItem = self.allMediaItems?[sender.tag] else { return }
        self.newSlowSongs.append(mediaItem)
        self.slowSongs.append(mediaItem)
        self.tableView.reloadData()
        
    }
    
}

extension SelectMusicViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allMediaItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectSongCell", for: indexPath) as! SelectSongCell
        guard let mediaItem = self.allMediaItems?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.songLabel.text = mediaItem.title
        cell.artistLabel.text = mediaItem.artist
        cell.durationLable.text = self.timeString(time: mediaItem.playbackDuration)
        
        cell.fastSongSelectedButton.setTitle(Strings.selectRunningSong, for: .normal)
        cell.fastSongSelectedButton.setTitleColor(#colorLiteral(red: 0.4091816725, green: 0.5505421041, blue: 0.7803921569, alpha: 1), for: .normal)
        cell.fastSongSelectedButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.fastSongSelectedButton.isEnabled = true
        cell.fastSongSelectedButton.tag = indexPath.row
        
        cell.slowSongSelectedButton.setTitle(Strings.selectWalkingSong, for: .normal)
        cell.slowSongSelectedButton.setTitleColor(#colorLiteral(red: 0.9072619132, green: 0.6691572433, blue: 0.9029235371, alpha: 1), for: .normal)
        cell.slowSongSelectedButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.slowSongSelectedButton.isEnabled = true
        cell.slowSongSelectedButton.tag = indexPath.row
        
        cell.fastSongSelectedButton.addTarget(self, action: #selector(selectRunningSong(_:)), for: .touchUpInside)
        cell.slowSongSelectedButton.addTarget(self, action: #selector(selectWalkingSong(_:)), for: .touchUpInside)
        for fastSong in self.fastSongs {
            if fastSong == self.allMediaItems![indexPath.row] {
                cell.fastSongSelectedButton.setTitle(Strings.selectedRunningSong, for: .normal)
                cell.fastSongSelectedButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
                cell.fastSongSelectedButton.backgroundColor = #colorLiteral(red: 0.4091816725, green: 0.5505421041, blue: 0.7803921569, alpha: 1)
//                cell.fastSongSelectedButton.isEnabled = false
            }
        }
        for slowSong in self.slowSongs {
            if slowSong == self.allMediaItems![indexPath.row] {
                cell.slowSongSelectedButton.setTitle(Strings.selectedWalkingSong, for: .normal)
                cell.slowSongSelectedButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
                cell.slowSongSelectedButton.backgroundColor = #colorLiteral(red: 0.9072619132, green: 0.6691572433, blue: 0.9029235371, alpha: 1)
//                cell.slowSongSelectedButton.isEnabled = false
            }
        }
        
        return cell
    }
    
}
