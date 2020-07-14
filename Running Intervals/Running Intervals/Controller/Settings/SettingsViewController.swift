//
//  SettingsViewController.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 09/07/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var myMusicButton: UIButton!
    @IBOutlet weak var myGoalButton: UIButton!
    @IBOutlet weak var personalInfoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setText()
        self.setCornerRadius()
    }
    
    func setText() {
        self.backButton.setTitle(Strings.back, for: .normal)
        self.headerLabel.text = Strings.settings
        self.myMusicButton.setTitle(Strings.myMusic, for: .normal)
        self.personalInfoButton.setTitle(Strings.personalInformaition, for: .normal)
        self.myGoalButton.setTitle(Strings.myGoal, for: .normal)

    }
    
    func setCornerRadius() {
        
        self.myMusicButton.layer.cornerRadius = self.myMusicButton.bounds.height / 2
        self.myMusicButton.layer.borderWidth = 2
        self.myMusicButton.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        
        self.myGoalButton.layer.cornerRadius = self.myGoalButton.bounds.height / 2
        self.myGoalButton.layer.borderWidth = 2
        self.myGoalButton.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        
        self.personalInfoButton.layer.cornerRadius = self.personalInfoButton.bounds.height / 2
        self.personalInfoButton.layer.borderWidth = 2
        self.personalInfoButton.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func myMusicButtonPressed(_ sender: Any) {
        let myMusicVC = Storyboards.Music.musicViewController
        self.present(myMusicVC, animated: true, completion: nil)
    }
    
    @IBAction func myGoalButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "presentMyGoal", sender: nil)
    }
    
    @IBAction func personalInfoButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "presentPersonalInfo", sender: nil)
    }
}
