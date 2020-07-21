//
//  MainViewController.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 01/06/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class MainViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var appImage: UIImageView!
    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var runByTimeButton: UIButton!
    @IBOutlet weak var runByDistanceButton: UIButton!
    @IBOutlet weak var buildProgramButton: UIButton!
    
    @IBOutlet weak var selectMusicButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    
    let allMediaItems = MPMediaQuery.songs().items
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setCornerRadius()
        self.setText()
        self.setImage()
    }
    
    func setImage() {
        if UserDefaultsProvider.shared.appLanguageCode == "he-IL" {
            self.appImage.image = #imageLiteral(resourceName: "runningWithMusic").imageFlippedForRightToLeftLayoutDirection()
        } else {
            self.appImage.image = #imageLiteral(resourceName: "runningWithMusic")
        }
    }
    
    func setCornerRadius() {
        
        self.runByTimeButton.layer.cornerRadius = self.runByTimeButton.bounds.height / 2
        self.runByTimeButton.layer.borderWidth = 2
        self.runByTimeButton.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        
        self.runByDistanceButton.layer.cornerRadius = self.runByDistanceButton.bounds.height / 2
        self.runByDistanceButton.layer.borderWidth = 2
        self.runByDistanceButton.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        
        self.buildProgramButton.layer.cornerRadius = self.buildProgramButton.bounds.height / 2
        self.buildProgramButton.layer.borderWidth = 2
        self.buildProgramButton.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        
        self.selectMusicButton.layer.cornerRadius = self.selectMusicButton.bounds.height / 2
        self.selectMusicButton.layer.borderWidth = 2
        self.selectMusicButton.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        
        self.settingsButton.layer.cornerRadius = self.settingsButton.bounds.height / 2
        self.settingsButton.layer.borderWidth = 2
        self.settingsButton.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        
        self.historyButton.layer.cornerRadius = self.historyButton.bounds.height / 2
        self.historyButton.layer.borderWidth = 2
        self.historyButton.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
    }

    func setText() {
        self.titelLabel.text = Strings.mainAppTitle
        self.settingsButton.setTitle(Strings.settings, for: .normal)
        self.selectMusicButton.setTitle(Strings.selectMusic, for: .normal)
        
        self.runByTimeButton.setTitle(Strings.runByTime, for: .normal)
        self.runByDistanceButton.setTitle(Strings.runByDistance, for: .normal)
        self.buildProgramButton.setTitle(Strings.buildProgram, for: .normal)
        self.historyButton.setTitle(Strings.history, for: .normal)
    }
    
    @IBAction func runByTimeButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "presentRunByTime", sender: true)
    }
    
    @IBAction func runByDistanceButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "presentRunByTime", sender: false)
    }
    
    @IBAction func buildProgramButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "presentTraining", sender: self)
    }
    
    @IBAction func selectMusicButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "presentSelectMusic", sender: self)
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "presentSettings", sender: self)
    }
    
    @IBAction func historyButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "presentHistory", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentRunByTime" {
            let runByTimeVC = segue.destination as! RunViewController
            runByTimeVC.isTimeMode = sender as? Bool ?? true
        }
    }
}
