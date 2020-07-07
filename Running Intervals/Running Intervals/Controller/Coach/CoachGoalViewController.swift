//
//  CoachGoalViewController.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 05/07/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit

enum GoalType: String {
    case eazy = "eazy"
    case medium = "medium"
    case hard = "hard"
}

class CoachGoalViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var eazyView: UIView!
    @IBOutlet weak var eazyTitleLabel: UILabel!
    @IBOutlet weak var eazyDescriptionLabel: UILabel!
    @IBOutlet weak var eazySelectButton: UIButton!
    
    @IBOutlet weak var mediumView: UIView!
    @IBOutlet weak var mediumTitleLabel: UILabel!
    @IBOutlet weak var mediumDescriptionLabel: UILabel!
    @IBOutlet weak var mediumSelectButton: UIButton!
    
    @IBOutlet weak var hardView: UIView!
    @IBOutlet weak var hardTitleLabel: UILabel!
    @IBOutlet weak var hardDescriptionLabel: UILabel!
    @IBOutlet weak var hardSelectButton: UIButton!
    
    var training: Training?
    var goalType: GoalType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setText()
        self.setCornerRadius()
        if UserDefaultsProvider.shared.goal != nil {
            self.performSegue(withIdentifier: "showDifficulty", sender: self)
        }
    }
    
    func setText() {
        self.headerLabel.text = "Select Yore Goal"
        
        self.eazyTitleLabel.text = "From 0 to 5 km"
        self.eazyDescriptionLabel.text = "8 weeks plan"
        
        self.mediumTitleLabel.text = "From 5 to 10 km"
        self.mediumDescriptionLabel.text = "14 weeks plan"
        
        self.hardTitleLabel.text = "From 10 to 21 km"
        self.hardDescriptionLabel.text = "18 weeks plan"
    }
    
    func setCornerRadius() {
        
        self.eazyView.layer.cornerRadius = 15
        self.eazyView.layer.borderWidth = 1
        self.eazyView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        self.mediumView.layer.cornerRadius = 15
        self.mediumView.layer.borderWidth = 1
        self.mediumView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        self.hardView.layer.cornerRadius = 15
        self.hardView.layer.borderWidth = 1
        self.hardView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        self.eazySelectButton.layer.cornerRadius = self.eazySelectButton.bounds.height / 2
        self.eazySelectButton.layer.borderWidth = 1
        self.eazySelectButton.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        
        self.mediumSelectButton.layer.cornerRadius = self.mediumSelectButton.bounds.height / 2
        self.mediumSelectButton.layer.borderWidth = 1
        self.mediumSelectButton.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        
        self.hardSelectButton.layer.cornerRadius = self.hardSelectButton.bounds.height / 2
        self.hardSelectButton.layer.borderWidth = 1
        self.hardSelectButton.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func eazyButtonPressed(_ sender: Any) {
        self.goalType = .eazy
        UserDefaultsProvider.shared.goal = self.goalType?.rawValue
        UserDefaultsProvider.shared.week = 1
        UserDefaultsProvider.shared.training = 1
        self.navigateToSelectWeek()
    }
    
    @IBAction func mediumButtonPressed(_ sender: Any) {
        self.goalType = .medium
        UserDefaultsProvider.shared.goal = self.goalType?.rawValue
        UserDefaultsProvider.shared.week = 1
        UserDefaultsProvider.shared.training = 24
        self.navigateToSelectWeek()
    }
    
    @IBAction func hardButtonPressed(_ sender: Any) {
        self.goalType = .hard
        UserDefaultsProvider.shared.goal = self.goalType?.rawValue
        UserDefaultsProvider.shared.week = 1
        UserDefaultsProvider.shared.training = 65
        self.navigateToSelectWeek()
    }
    
    //MARK: Navigation
    
    func navigateToSelectWeek() {
        self.performSegue(withIdentifier: "showDifficulty", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDifficulty" {
            let difficultyVC = segue.destination as! CoachDifficultyViewController
            difficultyVC.goalType = self.goalType
        }
    }
}
