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
    
    @IBOutlet weak var slowTF: UITextField!
    @IBOutlet weak var fastTF: UITextField!
    @IBOutlet weak var totalTimeTF: UITextField!
    @IBOutlet weak var timeLeftTitleLabel: UILabel!
    @IBOutlet weak var totalTimeLeftLabel: UILabel!
    
    @IBOutlet weak var runButton: UIButton!
    
    @IBOutlet weak var selectMusic: UIButton!
    @IBOutlet weak var myMusicButton: UIButton!
    
    var runningMediaItems: [MPMediaItem] = []
    var walkingMediaItems: [MPMediaItem] = []
    
    var fastSongsPersistentID: [String] = []
    var slowSongsPersistentID: [String] = []
    
    var player = MPMusicPlayerController.applicationQueuePlayer
    
    var isTimeMode: Bool = true
    var isRunning: Bool = false
    var isPlaying: Bool = false
    var isWalkingMode: Bool = true
    
    var run: Double = 0.0
    var walk: Double = 0.0
    var total: Double = 0.0
    
    let locationManager = CLLocationManager()
    private var seconds = 0
    private var timer: Timer?
    private var totalDistance = Measurement(value: 0, unit: UnitLength.meters)
    private var walkingDistance = Measurement(value: 0, unit: UnitLength.meters)
    private var runningDistance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    var currentLocation: CLLocation?
    var startingPoint: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setCornerRadius()
        self.runButton.isEnabled = false
        self.runButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        if self.isTimeMode {
            self.setTextForTimeMode()
        } else {
            self.setTextForDistanceMode()
        }
    
        self.currentLocation = locationManager.location
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.runningMediaItems = MusicRepository.shared.runningMediaItems
        self.walkingMediaItems = MusicRepository.shared.walkingMediaItems

    }
    
    func setTextForTimeMode() {
        self.timeForRuningLabel.text = Strings.insertTimeForRuning
        self.timeForWalkingLabel.text = Strings.insertTimeForWalking
        self.totalTimeLabel.text = Strings.insertTotalTime
        
        self.fastTF.placeholder = Strings.timeInSecons
        self.slowTF.placeholder = Strings.timeInSecons
        self.totalTimeTF.placeholder = Strings.timeInMinuts
        
        self.runButton.setTitle(Strings.runCaps, for: .normal)
        self.myMusicButton.setTitle(Strings.myMusic, for: .normal)
        self.selectMusic.setTitle(Strings.selectMusic, for: .normal)
    }
    
    func setTextForDistanceMode() {
        self.timeForRuningLabel.text = Strings.insertDistanceForRuning
        self.timeForWalkingLabel.text = Strings.insertDistanceForWalking
        self.totalTimeLabel.text = Strings.insertTotalDistance
        
        self.fastTF.placeholder = Strings.distanceInMetter
        self.slowTF.placeholder = Strings.distanceInMetter
        self.totalTimeTF.placeholder = Strings.distanceInKM
        
        self.runButton.setTitle(Strings.runCaps, for: .normal)
        self.myMusicButton.setTitle(Strings.myMusic, for: .normal)
        self.selectMusic.setTitle(Strings.selectMusic, for: .normal)
        
    }
    
    func setCornerRadius() {
        self.runButton.layer.cornerRadius = self.runButton.bounds.height / 2
        self.selectMusic.layer.cornerRadius = self.selectMusic.bounds.height / 2
        self.selectMusic.layer.borderWidth = 2
        self.selectMusic.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        
        self.myMusicButton.layer.cornerRadius = self.myMusicButton.bounds.height / 2
        self.myMusicButton.layer.borderWidth = 2
        self.myMusicButton.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
    }
    
    func playSlowSongForTimeMode(withDuration: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + withDuration, execute: {
            if !self.isPlaying { return }
            self.timeLeftTitleLabel.isHidden = false
            var counter = Int(self.walk)
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
            
            self.playFastSongForTimeMode(withDuration: self.walk)
        })
        
    }
    
    func playFastSongForTimeMode(withDuration: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + withDuration, execute: {
            if !self.isPlaying { return }
            var counter = Int(self.run)
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
            
            self.playSlowSongForTimeMode(withDuration: self.run)
        })
    }
    
    func playSlowSongForDistanceMode() {
        self.isWalkingMode = true
        let string = String(format:Strings.walkingDistanceLeft, "\(self.walk)")
        self.timeLeftTitleLabel.text = string
        
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        self.locationManager.startUpdatingLocation()
        let mediaCollection = MPMediaItemCollection(items: self.walkingMediaItems)
        self.player.setQueue(with: mediaCollection)
        self.player.play()
    }
    
    func playFastSongForDistanceMode() {
        self.isWalkingMode = false
        let string = String(format:Strings.runningDistanceLeft, "\(self.run)")
        self.timeLeftTitleLabel.text = string
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
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
    
    func setTotalDistanceLabel(distance: Int) {
        let string = String(format:Strings.totalDistanceLeft, "\(distance)")
        self.totalTimeLeftLabel.text = string
    }
    
    @IBAction func runButtonPressed(_ sender: Any) {
        self.isRunning.toggle()
        self.isPlaying = true
        if isRunning {
            self.runButton.setTitle(Strings.stopCaps, for: .normal)
            self.play()
        } else {
            self.runButton.setTitle(Strings.runCaps, for: .normal)
            self.trainingCompleted(0.0)
        }
        
    }
    
    func play() {
        if self.isTimeMode {
            self.trainingCompleted(self.total)
            self.playSlowSongForTimeMode(withDuration: 0.0)
            var counter = Int(self.total * 60.0)
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
                self.setTotalTimeLabel(time: Double(counter))
                counter -= 1
                if counter < 0 {
                    timer.invalidate()
                }
            }
        } else {
            if let location = currentLocation {
                self.startingPoint = location
            }
            let total = self.total * 1000
            self.setTotalDistanceLabel(distance: Int(total))
            
            self.playSlowSongForDistanceMode()
        }
    }
    
    @IBAction func selectMusicButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "presentSelectMusic", sender: self)
    }
    
    @IBAction func myMusicButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "presentMyMusic", sender: self)
    }
    
    func trainingCompleted(_ total: Double) {
        let total = total * 60
        DispatchQueue.main.asyncAfter(deadline: .now() + total) {
            self.run = 0.0
            self.walk = 0.0
            self.total = 0.0
            self.runButton.isEnabled = false
            self.runButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.runButton.setTitle("Done", for: .normal)
            self.timeLeftTitleLabel.isHidden = true
            self.totalTimeLeftLabel.isHidden = true
            self.isPlaying = false
            self.player.stop()
            self.locationManager.stopUpdatingLocation()
        }
        
    }
    
    func checkValidation() {
        if self.run == 0.0 {
            self.fastTF.becomeFirstResponder()
            self.fastTF.layer.borderWidth = 1
            self.fastTF.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        if self.walk == 0.0 {
            self.slowTF.becomeFirstResponder()
            self.slowTF.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        if self.total == 0.0 {
            self.totalTimeTF.becomeFirstResponder()
            self.totalTimeTF.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        if self.run > 0 && self.walk > 0 && self.total > 00 {
            self.runButton.backgroundColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
            self.runButton.isEnabled = true
        }
    }

}

extension RunViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fastTF {
            if let double = Double(textField.text!) {
                self.run = double
                self.slowTF.becomeFirstResponder()
            }
        } else if textField == slowTF {
            if let double = Double(textField.text!) {
                self.walk = double
                self.totalTimeTF.becomeFirstResponder()
            }
        } else {
            if let total = Double(textField.text!) {
                self.total = total
                textField.resignFirstResponder()
                
                self.checkValidation()
            }
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.runningMediaItems.count == 0 || self.walkingMediaItems.count == 0 {
            let alertController = UIAlertController(title: "", message: Strings.mustSelectMusic, preferredStyle: .alert)
            let okAction = UIAlertAction(title: Strings.cancel, style: .cancel, handler: nil)
            let selectMusic = UIAlertAction(title: Strings.selectMusic, style: .default) { (action) in
                self.performSegue(withIdentifier: "presentSelectMusic", sender: self)
            }
            alertController.addAction(selectMusic)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
    
}

extension RunViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                totalDistance = totalDistance + Measurement(value: delta, unit: UnitLength.meters)
                if self.isWalkingMode {
                    walkingDistance = walkingDistance + Measurement(value: delta, unit: UnitLength.meters)
                    let string = String(format:Strings.walkingDistanceLeft, "\(Int(self.walk - walkingDistance.value))")
                    self.timeLeftTitleLabel.text = string
                    let total = self.total * 1000
                    self.setTotalDistanceLabel(distance: Int(total - totalDistance.value))
                    if self.walk - walkingDistance.value <= 0.0 {
                        self.player.stop()
                        walkingDistance = Measurement(value: 0, unit: UnitLength.meters)
                        self.locationManager.stopUpdatingLocation()
                        self.playFastSongForDistanceMode()
                    }
                } else {
                    runningDistance = runningDistance + Measurement(value: delta, unit: UnitLength.meters)
                    let string = String(format:Strings.runningDistanceLeft, "\(Int(self.run - runningDistance.value))")
                    self.timeLeftTitleLabel.text = string
                    let total = self.total * 1000
                    self.setTotalDistanceLabel(distance: Int(total - totalDistance.value))
                    if self.run - runningDistance.value <= 0.0 {
                        self.player.stop()
                        runningDistance = Measurement(value: 0, unit: UnitLength.meters)
                        self.locationManager.stopUpdatingLocation()
                        self.playSlowSongForDistanceMode()
                    }
                }
                let total = self.total * 1000
                if total - totalDistance.value <= 0 {
                    self.trainingCompleted(0.0)
                }
            }
            locationList.append(newLocation)
        }
    }
    
}
