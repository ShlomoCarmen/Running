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
import CoreData

class CoachRunViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var runningLabel: UILabel!
    @IBOutlet weak var runningTitleLabel: UILabel!
    @IBOutlet weak var runningView: UIView!
    @IBOutlet weak var walkingLabel: UILabel!
    @IBOutlet weak var walkingTitleLabel: UILabel!
    @IBOutlet weak var walkingView: UIView!
    @IBOutlet weak var intervalsLabel: UILabel!
    @IBOutlet weak var intervalsView: UIView!

    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var timeLeftTitleLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var totalTimeLeftLabel: UILabel!
    
    @IBOutlet weak var trainingDoneView: UIView!
    @IBOutlet weak var trainingDoneLabel: UILabel!
    @IBOutlet weak var trainingDoneButton: UIButton!
    
    var weekNumber: Int?
    var training: [Training]?
    var currentTraining: Training?
    var goalType: GoalType?
    var trainingNumber: Int?
    var user: User?
    var runningMediaItems: [MPMediaItem] = []
    var walkingMediaItems: [MPMediaItem] = []
    
    var fastSongsPersistentID: [String] = []
    var slowSongsPersistentID: [String] = []
    var isPlaying: Bool = false
    var isRunning: Bool = false
    var player = MPMusicPlayerController.applicationQueuePlayer
    private var seconds = 0
    private var timer: Timer?
    private var totalDistance = Measurement(value: 0, unit: UnitLength.meters)
    var locationList: [CLLocation] = []
    let locationManager = CLLocationManager()
    var newRun: Run?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = UserDefaultsProvider.shared.user
        self.training = TrainingRepository.shared.getAllTraining()
        self.getCurrentTraining()
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

        guard let training = self.currentTraining else { return }
        self.headerLabel.text = "\(Strings.week) \(training.week) - \(Strings.training) \(training.training)" //traning.goal
        self.runningLabel.text = "\(training.timeForRun) \(Strings.minuts)"
        self.runningTitleLabel.text = "\(Strings.running)"
        self.walkingLabel.text = "\(training.timeForWalk) \(Strings.minuts)"
        self.walkingTitleLabel.text = "\(Strings.walking)"
        self.intervalsLabel.text = "\(training.intervals) \(Strings.times)"
        self.startButton.setTitle("\(Strings.start)", for: .normal)
        
    }
    
    func setCornerRadius() {
        self.startButton.layer.cornerRadius = self.startButton.bounds.height / 2
        self.runningView.layer.cornerRadius = 20
        self.walkingView.layer.cornerRadius = 20
        self.intervalsView.layer.cornerRadius = self.intervalsView.bounds.height / 2
        self.trainingDoneButton.layer.cornerRadius = self.trainingDoneButton.bounds.height / 2
        self.trainingDoneButton.layer.borderWidth = 2
        self.trainingDoneButton.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
    }
    
    func getCurrentTraining() {
        guard let goalType = self.goalType?.rawValue, let week = self.weekNumber, let trainingNumber = self.trainingNumber else { return }
        guard let allTraining = self.training else { return }
        for training in allTraining {
            if training.goal == goalType && training.week == week && training.training == trainingNumber {
                self.currentTraining = training
                let sessionId = training.sessionId
                self.getCompletedRun(sessionId: sessionId)
            }
        }
    }
    
    func getCompletedRun(sessionId: String) {
        let request: NSFetchRequest<Run> = Run.fetchRequest()
        do {
            var runs: [Run] = []
            let result = try CoreDataManager.context.fetch(request)
            for data in result {
                if data.sessionId == sessionId {
                    runs.append(data)
                }
            }
            let sortedRun = runs.sorted(by: {$0.timestamp!.timeIntervalSince1970 < $1.timestamp!.timeIntervalSince1970})
            self.newRun = sortedRun.last
            if self.newRun != nil {
                self.performSegue(withIdentifier: "presentStatistics", sender: self)
            }
        } catch {
            print("Failed")
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        self.isPlaying = true
        self.startButton.setTitle("", for: .normal)
        self.startButton.isEnabled = false
        self.play()
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
    
    func setTimeLabel(time: TimeInterval) {
        let minutes = Int(time/60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        let minutesString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let secondsString = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        self.timeLeftLabel.text = "\(minutesString):\(secondsString)"
    }
    
    func playSlowSong(withDuration: Double) {
        guard let training = self.currentTraining else { return }
        self.locationManager.startUpdatingLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + withDuration, execute: {
            if !self.isPlaying { return }
            self.startButton.backgroundColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
            self.timeLeftTitleLabel.isHidden = false
            var counter = training.timeForWalk * 60
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in

                self.timeLeftTitleLabel.text = "\(Strings.walkingFor)"
                self.setTimeLabel(time: Double(counter))
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
            self.startButton.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
            var counter = training.timeForRun * 60
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in

                self.timeLeftTitleLabel.text = "\(Strings.runningFor)"
                self.setTimeLabel(time: Double(counter))
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
            self.startButton.backgroundColor = #colorLiteral(red: 0, green: 0.3019607843, blue: 0.631372549, alpha: 1)
            self.startButton.setTitle("\(Strings.done)", for: .normal)
            self.timeLeftTitleLabel.isHidden = true
            self.timeLeftLabel.isHidden = true
            self.totalTimeLeftLabel.isHidden = true
            self.isPlaying = false
            self.player.stop()
            self.locationManager.stopUpdatingLocation()
            self.timer?.invalidate()
            
            self.trainingDone()
        }
    }
    
    func trainingDone() {
        self.saveRun()
        self.trainingDoneView.isHidden = false
        self.trainingDoneLabel.text = "\(Strings.trainingCompletedMessage)"
        self.trainingDoneButton.setTitle("\(Strings.showStatistics)", for: .normal)
        
    }
    
    private func saveRun() {
        guard let training = self.currentTraining else { return }
        let run = Run(context: CoreDataManager.context)
        run.distance = totalDistance.value
        run.duration = Int16(seconds)
        run.timestamp = Date()
        run.sessionId = training.sessionId
        run.calories = self.getCalories(duration: Double(seconds) / 60)
        
        for location in locationList {
            let locationObject = Location(context: CoreDataManager.context)
            locationObject.timestamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            run.addToLocations(locationObject)
        }
        
        CoreDataManager.saveContext()
        
        self.newRun = run

    }
    
    func getCalories(duration: Double) -> String {
        guard let user = self.user else { return "No Info"}
        let met = Double(duration) * 6.0 * (3.5 * Double(user.weight))
        let calories = (met / 200)
        let displayCalories = String(format: "%.2f", calories)
        return displayCalories
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentStatistics" {
            let statisticsVC = segue.destination as! LastRunViewController
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
