//
//  CoachRunViewController.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 04/06/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import CoreLocation

class CoachRunViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var weekNumber: Int?
    var training: [Training]?
    var currentTraining: Training?
    var goalType: GoalType?
    
    var runningMediaItems: [MPMediaItem] = []
    var walkingMediaItems: [MPMediaItem] = []
    
    var fastSongsPersistentID: [String] = []
    var slowSongsPersistentID: [String] = []
    
    var player = MPMusicPlayerController.applicationQueuePlayer
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.training = TrainingRepository.shared.getAllTraining()
        self.setText()
        self.setCornerRadius()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.runningMediaItems = MusicRepository.shared.runningMediaItems
        self.walkingMediaItems = MusicRepository.shared.walkingMediaItems

    }
    
    func setText() {
        let trainingNumber = UserDefaultsProvider.shared.training - 1
        guard let traning = self.training?[trainingNumber] else { return }
        self.currentTraining = traning
        self.headerLabel.text = traning.goal
        self.titleLabel.text = "Week \(traning.week), Training \(traning.training)"
        self.descriptionLabel.text = traning.descreption
        
    }
    
    func setCornerRadius() {
        self.startButton.layer.cornerRadius = self.startButton.bounds.height / 2
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if UserDefaultsProvider.shared.training <= 120 {
            UserDefaultsProvider.shared.training += 1            
        }  
    }
    
    
}
