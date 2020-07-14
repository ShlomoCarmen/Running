//
//  RunViewController.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 24/05/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import CoreLocation

class RunViewController: UIViewController {
    
    @IBOutlet weak var timeForRuningLabel: UILabel!
    @IBOutlet weak var timeForWalkingLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var slowTF: UITextField!
    @IBOutlet weak var fastTF: UITextField!
    @IBOutlet weak var totalTimeTF: UITextField!
    @IBOutlet weak var timeLeftTitleLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var totalTimeLeftLabel: UILabel!
    
    @IBOutlet weak var trainingView: UIView!
    @IBOutlet weak var runningLabel: UILabel!
    @IBOutlet weak var runningTitleLabel: UILabel!
    @IBOutlet weak var runningView: UIView!
    @IBOutlet weak var walkingLabel: UILabel!
    @IBOutlet weak var walkingTitleLabel: UILabel!
    @IBOutlet weak var walkingView: UIView!
    @IBOutlet weak var intervalsLabel: UILabel!
    @IBOutlet weak var intervalsView: UIView!

    @IBOutlet weak var runButton: UIButton!
    
    @IBOutlet weak var selectMusic: UIButton!
    @IBOutlet weak var myMusicButton: UIButton!
    
    @IBOutlet weak var trainingDoneView: UIView!
    @IBOutlet weak var trainingDoneLabel: UILabel!
    @IBOutlet weak var trainingDoneButton: UIButton!
    
    var runningMediaItems: [MPMediaItem] = []
    var walkingMediaItems: [MPMediaItem] = []
    
    var fastSongsPersistentID: [String] = []
    var slowSongsPersistentID: [String] = []
    
    var player = MPMusicPlayerController.applicationQueuePlayer
    
    var isTimeMode: Bool = true
    var isRunning: Bool = false
    var isPlaying: Bool = false
    var isWalkingMode: Bool = true
    
    let locationManager = CLLocationManager()
    private var seconds = 0
    private var timer: Timer?
    private var totalDistance = Measurement(value: 0, unit: UnitLength.meters)
    private var walkingDistance = Measurement(value: 0, unit: UnitLength.meters)
    private var runningDistance = Measurement(value: 0, unit: UnitLength.meters)
    var locationList: [CLLocation] = []
    var newRun: Run?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.trainingView.isHidden = true
        self.setCornerRadius()
        self.setText()
        if self.isTimeMode {
            self.setTextForTimeMode()
        } else {
            self.setTextForDistanceMode()
        }
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.trainingDoneView.isHidden = true
        self.runningMediaItems = MusicRepository.shared.runningMediaItems
        self.walkingMediaItems = MusicRepository.shared.walkingMediaItems

        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
    }
    
    func setText() {
        self.runButton.setTitle(Strings.start, for: .normal)
        self.myMusicButton.setTitle(Strings.myMusic, for: .normal)
        self.selectMusic.setTitle(Strings.selectMusic, for: .normal)
    }
    
    func setTextForTimeMode() {
        self.timeForRuningLabel.text = Strings.insertTimeForRunning
        self.timeForWalkingLabel.text = Strings.insertTimeForWalking
        self.totalTimeLabel.text = Strings.insertTotalTime
        
        self.fastTF.placeholder = Strings.timeInMinuts
        self.slowTF.placeholder = Strings.timeInMinuts
        self.totalTimeTF.placeholder = Strings.timeInMinuts
    }
    
    func setTextForDistanceMode() {
        self.timeForRuningLabel.text = Strings.insertDistanceForRunning
        self.timeForWalkingLabel.text = Strings.insertDistanceForWalking
        self.totalTimeLabel.text = Strings.insertTotalDistance
        
        self.fastTF.placeholder = Strings.distanceInMeter
        self.slowTF.placeholder = Strings.distanceInMeter
        self.totalTimeTF.placeholder = Strings.distanceInKM
        
    }
    
    func setCornerRadius() {
        self.runButton.layer.cornerRadius = self.runButton.bounds.height / 2
        self.selectMusic.layer.cornerRadius = self.selectMusic.bounds.height / 2
        self.selectMusic.layer.borderWidth = 2
        self.selectMusic.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        
        self.myMusicButton.layer.cornerRadius = self.myMusicButton.bounds.height / 2
        self.myMusicButton.layer.borderWidth = 2
        self.myMusicButton.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        
        self.runningView.layer.cornerRadius = 20
        self.walkingView.layer.cornerRadius = 20
        self.intervalsView.layer.cornerRadius = self.intervalsView.bounds.height / 2
        self.trainingDoneButton.layer.cornerRadius = self.trainingDoneButton.bounds.height / 2
        self.trainingDoneButton.layer.borderWidth = 2
        self.trainingDoneButton.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
    }
    
    func playSlowSongForTimeMode(withDuration: Double) {
        self.locationManager.startUpdatingLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + withDuration, execute: {
            if !self.isPlaying { return }
            self.runButton.backgroundColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
            self.timeLeftTitleLabel.isHidden = false
            guard let walk = self.slowTF.text else { return }
            guard let counter = Double(walk) else { return }
            var displayCounter = counter * 60
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
                self.timeLeftTitleLabel.text = "\(Strings.walkingFor)"
                self.setTimeLabel(time: displayCounter)
                displayCounter -= 1
                if displayCounter < 0 {
                    timer.invalidate()
                }
            }
            let mediaCollection = MPMediaItemCollection(items: self.walkingMediaItems)
            self.player.setQueue(with: mediaCollection)
            self.player.play()
            if let walkingTime = Double(walk) {
                self.playFastSongForTimeMode(withDuration: walkingTime * 60)
            }
        })
        
    }
    
    func playFastSongForTimeMode(withDuration: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + withDuration, execute: {
            if !self.isPlaying { return }
            self.runButton.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
            guard let run = self.fastTF.text else { return }
            guard let counter = Double(run) else { return }
            var displayCounter = counter * 60
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
                self.timeLeftTitleLabel.text = "\(Strings.walkingFor)"
                self.setTimeLabel(time: displayCounter)
                displayCounter -= 1
                if displayCounter < 0 {
                    timer.invalidate()
                }
            }
            let mediaCollection = MPMediaItemCollection(items: self.runningMediaItems)
            self.player.setQueue(with: mediaCollection)
            self.player.play()
            if let runningTime = Double(run) {
                self.playSlowSongForTimeMode(withDuration: runningTime * 60)
            }
        })
    }
    
    func playSlowSongForDistanceMode() {
        self.isWalkingMode = true
        self.runButton.backgroundColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
        guard let walk = self.slowTF.text else { return }
        self.timeLeftTitleLabel.text = "\(Strings.walking)"
        if let doubelWalk = Double(walk) {
            self.setTimeLabelForDistanceMode(time: doubelWalk)
        }
        self.locationManager.startUpdatingLocation()
        let mediaCollection = MPMediaItemCollection(items: self.walkingMediaItems)
        self.player.setQueue(with: mediaCollection)
        self.player.play()
    }
    
    func playFastSongForDistanceMode() {
        self.isWalkingMode = false
        self.runButton.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
        guard let run = self.fastTF.text else { return }
        self.timeLeftLabel.text = run
        self.timeLeftTitleLabel.text = "\(Strings.running)"
        if let doubelRun = Double(run) {
            self.setTimeLabelForDistanceMode(time: doubelRun)
        }
        self.locationManager.startUpdatingLocation()
        let mediaCollection = MPMediaItemCollection(items: self.runningMediaItems)
        self.player.setQueue(with: mediaCollection)
        self.player.play()
        
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

    func setTimeLabelForDistanceMode(time: TimeInterval) {
        if time < 1000.0 {
//            let displayTotal = String(format: "%.2f", time)
            self.timeLeftLabel.text = "\(Int(time))"
        } else {
            let total = time / 1000
            let displayTotal = String(format: "%.2f", total)
            self.timeLeftLabel.text = displayTotal
        }
    }
    
    func setTotalDistanceLabel(distance: Int) {
        let string = String(format:Strings.totalDistanceLeft, "\(distance)")
        self.totalTimeLeftLabel.text = string
    }
    
    func setRunningModeUI(_ timeForRun: String, _ timeForWalk: String, _ total: String) {
        self.trainingView.isHidden = false
        self.textFieldView.isHidden = true
        self.runningTitleLabel.text = "\(Strings.running)"
        self.walkingTitleLabel.text = "\(Strings.walking)"
        guard let run = Double(timeForRun), let walk = Double(timeForWalk), let total = Double(total) else { return }
        let intervals = total / (run + walk)
        let displayTotal = String(format: "%.2f", intervals)
        self.intervalsLabel.text = "\(displayTotal) \(Strings.times)"
        if self.isTimeMode {
            self.runningLabel.text = "\(timeForRun) \(Strings.minuts)"
            self.walkingLabel.text = "\(timeForWalk) \(Strings.minuts)"
        } else {
            self.runningLabel.text = "\(timeForRun) \(Strings.meter)"
            self.walkingLabel.text = "\(timeForWalk) \(Strings.meter)"
        }
    }
    
    @IBAction func runButtonPressed(_ sender: Any) {
        guard let run = self.fastTF.text, let walk = self.slowTF.text, let total = self.totalTimeTF.text else { return }
        if self.checkValidation() {
            self.view.endEditing(true)
            self.isPlaying = true
            self.runButton.setTitle("", for: .normal)
            self.runButton.isEnabled = false
            self.play()
            self.setRunningModeUI(run, walk, total)
        }
        
    }
    
    func play() {
        guard let total = self.totalTimeTF.text else { return }
        guard let totalDoubel = Double(total) else { return }
        if self.isTimeMode {
            self.trainingCompleted(totalDoubel)
            self.playSlowSongForTimeMode(withDuration: 0.0)
            var counter = totalDoubel * 60.0
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
                self.seconds += 1
                self.setTotalTimeLabel(time: Double(counter))
                counter -= 1
                if counter < 0 {
                    timer.invalidate()
                }
            }
        } else {
            let total = totalDoubel * 1000.0
            self.setTotalDistanceLabel(distance: Int(total))
            
            self.playSlowSongForDistanceMode()
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                self.seconds += 1
            }
        }
    }
    
    @IBAction func selectMusicButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "presentSelectMusic", sender: self)
    }
    
    @IBAction func myMusicButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "presentMyMusic", sender: self)
    }
    
    @IBAction func trainingDoneButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "presentStatistics", sender: self)
    }
    
    func trainingCompleted(_ total: Double) {
        let total = total * 60
        DispatchQueue.main.asyncAfter(deadline: .now() + total) {
            self.runButton.isEnabled = false
            self.runButton.backgroundColor = #colorLiteral(red: 0, green: 0.3019607843, blue: 0.631372549, alpha: 1)
            self.runButton.setTitle(Strings.done, for: .normal)
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
    
    func checkValidation() -> Bool {
        if self.fastTF.text == "" {
            self.fastTF.becomeFirstResponder()
            self.fastTF.layer.borderWidth = 1
            self.fastTF.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            return false
        }
        if self.slowTF.text == "" {
            self.slowTF.becomeFirstResponder()
            self.slowTF.layer.borderWidth = 1
            self.slowTF.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            return false
        }
        if self.totalTimeTF.text == "" {
            self.totalTimeTF.becomeFirstResponder()
            self.totalTimeTF.layer.borderWidth = 1
            self.totalTimeTF.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            return false
        }
        return true
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

extension RunViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fastTF {
            self.slowTF.becomeFirstResponder()
        } else if textField == slowTF {
            self.totalTimeTF.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if self.runningMediaItems.count == 0 || self.walkingMediaItems.count == 0 {
//            let alertController = UIAlertController(title: "", message: Strings.mustSelectMusic, preferredStyle: .alert)
//            let okAction = UIAlertAction(title: Strings.cancel, style: .cancel, handler: nil)
//            let selectMusic = UIAlertAction(title: Strings.selectMusic, style: .default) { (action) in
//                self.performSegue(withIdentifier: "presentSelectMusic", sender: self)
//            }
//            alertController.addAction(selectMusic)
//            alertController.addAction(okAction)
//            self.present(alertController, animated: true, completion: nil)
//        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
    
}

extension RunViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.isTimeMode {
            for newLocation in locations {
                let howRecent = newLocation.timestamp.timeIntervalSinceNow
                guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
                if let lastLocation = locationList.last {
                    let delta = newLocation.distance(from: lastLocation)
                    totalDistance = totalDistance + Measurement(value: delta, unit: UnitLength.meters)
                }
                locationList.append(newLocation)
            }
        } else {
            for newLocation in locations {
                let howRecent = newLocation.timestamp.timeIntervalSinceNow
                guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
                guard let total = self.totalTimeTF.text else { return }
                guard let totalDoubel = Double(total) else { return }
                if let lastLocation = locationList.last {
                    let delta = newLocation.distance(from: lastLocation)
                    totalDistance = totalDistance + Measurement(value: delta, unit: UnitLength.meters)
                    if self.isWalkingMode {
                        guard let walk = self.slowTF.text else { return }
                        if let distance = Double(walk) {
                        walkingDistance = walkingDistance + Measurement(value: delta, unit: UnitLength.meters)
                            self.timeLeftTitleLabel.text = "\(Strings.walkingFor)"
                            self.setTimeLabelForDistanceMode(time: distance - walkingDistance.value)
                            let total = totalDoubel * 1000.0
                        self.setTotalDistanceLabel(distance: Int(total - totalDistance.value))
                        if distance - walkingDistance.value <= 0.0 {
                            self.player.stop()
                            walkingDistance = Measurement(value: 0, unit: UnitLength.meters)
                            self.locationManager.stopUpdatingLocation()
                            self.playFastSongForDistanceMode()
                        }
                        }
                    } else {
                        guard let run = self.fastTF.text else { return }
                        if let distance = Double(run) {
                            runningDistance = runningDistance + Measurement(value: delta, unit: UnitLength.meters)
                            self.timeLeftTitleLabel.text = "\(Strings.running)"
                            self.setTimeLabelForDistanceMode(time: distance - runningDistance.value)
                            let total = totalDoubel * 1000.0
                            self.setTotalDistanceLabel(distance: Int(total - totalDistance.value))
                            if distance - runningDistance.value <= 0.0 {
                                self.player.stop()
                                runningDistance = Measurement(value: 0, unit: UnitLength.meters)
                                self.locationManager.stopUpdatingLocation()
                                self.playSlowSongForDistanceMode()
                            }
                        }
                    }
                    let total = totalDoubel * 1000.0
                    if total - totalDistance.value <= 0 {
                        self.trainingCompleted(0.0)
                    }
                }
                locationList.append(newLocation)
            }
        }
    }
    
}
