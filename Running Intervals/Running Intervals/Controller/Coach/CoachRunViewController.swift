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
    
    @IBOutlet weak var timeLeftTitleLabel: UILabel!
    @IBOutlet weak var totalTimeLeftLabel: UILabel!
    
    @IBOutlet weak var trainingDoneView: UIView!
    @IBOutlet weak var trainingDoneLabel: UILabel!
    @IBOutlet weak var trainingDoneButton: UIButton!
    
    var weekNumber: Int?
    var training: [Training]?
    var currentTraining: Training?
    var goalType: GoalType?
    
    var runningMediaItems: [MPMediaItem] = []
    var walkingMediaItems: [MPMediaItem] = []
    
    var fastSongsPersistentID: [String] = []
    var slowSongsPersistentID: [String] = []
    var isPlaying: Bool = false
    var player = MPMusicPlayerController.applicationQueuePlayer
    private var seconds = 0
    private var timer: Timer?
    private var totalDistance = Measurement(value: 0, unit: UnitLength.meters)
    var locationList: [CLLocation] = []
    let locationManager = CLLocationManager()
    var newRun: Run?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.training = TrainingRepository.shared.getAllTraining()
        self.setText()
        self.setCornerRadius()
        self.trainingDoneView.isHidden = true
    
        self.locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
        self.isPlaying = true
        self.play()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if UserDefaultsProvider.shared.training <= 120 {
            UserDefaultsProvider.shared.training += 1            
        }  
    }
    
    @IBAction func trainingDoneButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "presentStatistics", sender: self)
    }
    
    func play() {
        guard let training = self.currentTraining else { return }
        self.playSlowSong(withDuration: 0.0)
        let total = (training.timeForRun * 60 + training.timeForWalk * 60) * training.intervals
        self.trainingCompleted(Double(total))
        var counter = total
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            self.seconds += 1
            self.setTotalTimeLabel(time: Double(counter))
            counter -= 1
            if counter < 0 {
                timer.invalidate()
            }
        }
    }
    
    func setTotalTimeLabel(time: TimeInterval) {
        let minutes = Int(time/60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        let minutesString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let secondsString = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        self.totalTimeLeftLabel.text = "\(Strings.totalTimeLeft) \(minutesString):\(secondsString)"
    }
    
    func playSlowSong(withDuration: Double) {
        guard let training = self.currentTraining else { return }
        self.locationManager.startUpdatingLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + withDuration, execute: {
            if !self.isPlaying { return }
            self.timeLeftTitleLabel.isHidden = false
            var counter = training.timeForWalk * 60
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
                let string = String(format:Strings.walkingTimeLeft, "\(counter)")
                self.timeLeftTitleLabel.text = string
                counter -= 1
                if counter < 0 {
                    timer.invalidate()
                }
            }
            let mediaCollection = MPMediaItemCollection(items: self.walkingMediaItems)
            self.player.setQueue(with: mediaCollection)
            self.player.play()
            
            self.playFastSong(withDuration: Double(training.timeForWalk * 60))
        })
        
    }
    
    func playFastSong(withDuration: Double) {
        guard let training = self.currentTraining else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + withDuration, execute: {
            if !self.isPlaying { return }
            var counter = training.timeForRun * 60
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
                let string = String(format:Strings.runningTimeLeft, "\(counter)")
                self.timeLeftTitleLabel.text = string
                counter -= 1
                if counter < 0 {
                    timer.invalidate()
                }
            }
            let mediaCollection = MPMediaItemCollection(items: self.runningMediaItems)
            self.player.setQueue(with: mediaCollection)
            self.player.play()
            
            self.playSlowSong(withDuration: Double(training.timeForRun * 60))
        })
    }
    
    func trainingCompleted(_ total: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            self.startButton.isEnabled = false
            self.startButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.startButton.setTitle("Done", for: .normal)
            self.timeLeftTitleLabel.isHidden = true
            self.totalTimeLeftLabel.isHidden = true
            self.isPlaying = false
            self.player.stop()
            self.locationManager.stopUpdatingLocation()
            self.timer?.invalidate()
            
            if UserDefaultsProvider.shared.training <= 120 {
                UserDefaultsProvider.shared.training += 1
            }
            self.trainingDone()
        }
    }
    
    func trainingDone() {
        self.saveRun()
        self.trainingDoneView.isHidden = false
        self.trainingDoneLabel.text = "Congratulations, you have reached your goal"
        self.trainingDoneButton.setTitle("Show Statistics", for: .normal)
    }
    
    private func saveRun() {
        let run = Run(context: CoreDataManager.context)
        run.distance = totalDistance.value
        run.duration = Int16(seconds)
        run.timestamp = Date()
        
        for location in locationList {
            let locationObject = Location(context: CoreDataManager.context)
            locationObject.timestamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            run.addToLocation(locationObject)
        }
        
        CoreDataManager.saveContext()
        
        self.newRun = run
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentStatistics" {
            let statisticsVC = segue.destination as! LastRunViewController
            statisticsVC.locationList = self.locationList
            statisticsVC.totalDistance = self.totalDistance
            statisticsVC.run = self.newRun
        }
    }
}

extension CoachRunViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                totalDistance = totalDistance + Measurement(value: delta, unit: UnitLength.meters)
            }
            locationList.append(newLocation)
        }
    }
    
}
