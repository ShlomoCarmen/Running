//
//  MyMusicViewController.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 31/05/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit
import MediaPlayer

class MyMusicViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var fastSongs: [MPMediaItem] = []
    var slowSongs: [MPMediaItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.fastSongs = MusicRepository.shared.runningMediaItems
        self.slowSongs = MusicRepository.shared.walkingMediaItems
        self.setText()
    }
    
    func setText() {
        self.titleLabel.text = Strings.myMusic
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
        UserDefaultsProvider.shared.fastSongs = []
        for song in fastSongs {
            let mediaItemPersistentID = String(song.persistentID)
            UserDefaultsProvider.shared.fastSongs.append(mediaItemPersistentID)
        }
        MusicRepository.shared.runningMediaItems = self.fastSongs
    }
    
    func saveSlowSongs() {
        UserDefaultsProvider.shared.slowSongs = []
        for song in slowSongs {
            let mediaItemPersistentID = String(song.persistentID)
            UserDefaultsProvider.shared.slowSongs.append(mediaItemPersistentID)
        }
        MusicRepository.shared.walkingMediaItems = self.slowSongs
    }
}

extension MyMusicViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return Strings.myRunningMusic
        case 1:
            return Strings.myWalkingMusic
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if self.fastSongs.count > 0 {
                return self.fastSongs.count
            } else {
                return 0
            }
        case 1:
            if self.slowSongs.count > 0 {
                return self.slowSongs.count
            } else {
                return 0
            }
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "myMusicCell", for: indexPath) as! MyMusicCell
            if self.fastSongs.count > 0 {
                let mediaItem = fastSongs[indexPath.row]
                cell.songLabel.text = mediaItem.title
                cell.artistLabel.text = mediaItem.artist
                cell.durationLable.text = self.timeString(time: mediaItem.playbackDuration)
            } else {
                cell.songLabel.text = "No Music Selected"
                cell.artistLabel.isHidden = true
                cell.durationLable.isHidden = true
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "myMusicCell", for: indexPath) as! MyMusicCell
            if self.slowSongs.count > 0 {
                let mediaItem = slowSongs[indexPath.row]
                cell.songLabel.text = mediaItem.title
                cell.artistLabel.text = mediaItem.artist
                cell.durationLable.text = self.timeString(time: mediaItem.playbackDuration)
            } else {
                cell.songLabel.text = "No Music Selected"
                cell.artistLabel.isHidden = true
                cell.durationLable.isHidden = true
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if self.fastSongs.count == 0 {
                break
            }
            if editingStyle == .delete {
                fastSongs.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case 1:
            if self.slowSongs.count == 0 {
                break
            }
            if editingStyle == .delete {
                slowSongs.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        default:
            break
        }
        
    }
}
