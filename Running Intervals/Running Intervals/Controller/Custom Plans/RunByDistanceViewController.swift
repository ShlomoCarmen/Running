//
//  RunByDistanceViewController.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 02/06/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit
import MediaPlayer

class RunByDistanceViewController: UIViewController {
    
    @IBOutlet weak var distanceForRuningLabel: UILabel!
    @IBOutlet weak var distanceForWalkingLabel: UILabel!
    @IBOutlet weak var totalDistanceLabel: UILabel!
    
    @IBOutlet weak var slowTF: UITextField!
    @IBOutlet weak var fastTF: UITextField!
    @IBOutlet weak var totalDistanceTF: UITextField!
    
    @IBOutlet weak var distanceLeftTitleLabel: UILabel!
    @IBOutlet weak var totalDistanceLeftLabel: UILabel!
    
    @IBOutlet weak var runButton: UIButton!
    
    @IBOutlet weak var selectMusicButton: UIButton!
    @IBOutlet weak var myMusicButton: UIButton!
    
    var runningMediaItems: [MPMediaItem] = []
    var walkingMediaItems: [MPMediaItem] = []
    
    var isRunning: Bool = false
    var isPlaying: Bool = false
    var player = MPMusicPlayerController.applicationQueuePlayer
    
    var runnungDistance: Int = 0
    var walkingDistance: Int = 0
    var totalDistance: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setText()
        self.setCornerRadius()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.runningMediaItems = MusicRepository.shared.runningMediaItems
        self.walkingMediaItems = MusicRepository.shared.walkingMediaItems
    }
    
    func setCornerRadius() {
        self.runButton.layer.cornerRadius = self.runButton.bounds.height / 2
        self.selectMusicButton.layer.cornerRadius = self.selectMusicButton.bounds.height / 2
        self.selectMusicButton.layer.borderWidth = 2
        self.selectMusicButton.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        
        self.myMusicButton.layer.cornerRadius = self.myMusicButton.bounds.height / 2
        self.myMusicButton.layer.borderWidth = 2
        self.myMusicButton.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
    }
    
    
    func setText() {
        self.distanceForRuningLabel.text = Strings.insertDistanceForRunning
        self.distanceForWalkingLabel.text = Strings.insertDistanceForWalking
        self.totalDistanceLabel.text = Strings.insertTotalDistance
        
        self.fastTF.placeholder = Strings.distanceInMeter
        self.slowTF.placeholder = Strings.distanceInMeter
        self.totalDistanceTF.placeholder = Strings.distanceInKM
        
        self.runButton.setTitle(Strings.runCaps, for: .normal)
        self.myMusicButton.setTitle(Strings.myMusic, for: .normal)
        self.selectMusicButton.setTitle(Strings.selectMusic, for: .normal)
        
    }
    
    @IBAction func selectMusicButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "presentSelectMusic", sender: self)
    }
    
    @IBAction func myMusicButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "presentMyMusic", sender: self)
    }
    
    @IBAction func runButtonPressed(_ sender: Any) {
        let total = Double(self.totalDistance)
        self.trainingCompleted(total)
        self.isRunning.toggle()
        self.isPlaying = true
        if isRunning {
            self.runButton.setTitle(Strings.stopCaps, for: .normal)
//            self.playSlowSong(withDuration: 0.0)
            
        } else {
            self.runButton.setTitle(Strings.runCaps, for: .normal)
            self.trainingCompleted(0.0)
        }
        
        var counter = self.totalDistance * 100
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            self.totalDistanceLeftLabel.text = ""
            counter -= 1
            if counter < 0 {
                timer.invalidate()
            }
        }
    }
    
    func trainingCompleted(_ total: Double) {
        let total = total * 60
        DispatchQueue.main.asyncAfter(deadline: .now() + total) {
            self.runnungDistance = 0
            self.walkingDistance = 0
            self.totalDistance = 0
            self.runButton.isEnabled = false
            self.runButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.distanceLeftTitleLabel.isHidden = true
            self.totalDistanceLeftLabel.isHidden = true
//            self.isPlaying = false
            self.player.stop()
        }
        
    }
    
    func checkValidation() {
        if self.runnungDistance == 0 {
            self.fastTF.becomeFirstResponder()
            self.fastTF.layer.borderWidth = 1
            self.fastTF.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        if self.walkingDistance == 0 {
            self.slowTF.becomeFirstResponder()
            self.slowTF.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        if self.totalDistance == 0 {
            self.totalDistanceTF.becomeFirstResponder()
            self.totalDistanceTF.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        if self.runnungDistance > 0 && self.walkingDistance > 0 && self.totalDistance > 00 {
            self.runButton.backgroundColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
            self.runButton.isEnabled = true
        }
    }
}

extension RunByDistanceViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fastTF {
            if let distance = Int(textField.text!) {
                self.runnungDistance = distance
                self.slowTF.becomeFirstResponder()
            }
        } else if textField == slowTF {
            if let distance = Int(textField.text!) {
                self.walkingDistance = distance
                self.totalDistanceTF.becomeFirstResponder()
            }
        } else {
            if let distance = Int(textField.text!) {
                self.totalDistance = distance
                textField.resignFirstResponder()
            }
            self.checkValidation()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.runningMediaItems.count == 0 || self.walkingMediaItems.count == 0 {
            let alertController = UIAlertController(title: "", message: "עליך לבחור מוזיקה", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
}
