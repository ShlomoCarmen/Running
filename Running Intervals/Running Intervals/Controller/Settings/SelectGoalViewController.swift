//
//  SelectGoalViewController.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 05/07/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit

enum GoalType: String {
    case eazy = "5 km"
    case medium = "10 km"
    case hard = "21 km"
}

class SelectGoalViewController: UIViewController {

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

    }
    
    func setText() {
        self.headerLabel.text = Strings.goalTitle
        
        self.eazyTitleLabel.text = Strings.eazyGoalTitle
        self.eazyDescriptionLabel.text = Strings.eazyGoalDescription
        self.eazySelectButton.setTitle(Strings.select, for: .normal)
        
        self.mediumTitleLabel.text = Strings.mediumGoalTitle
        self.mediumDescriptionLabel.text = Strings.mediumGoalDescription
        self.mediumSelectButton.setTitle(Strings.select, for: .normal)
        
        self.hardTitleLabel.text = Strings.hardGoalTitle
        self.hardDescriptionLabel.text = Strings.hardGoalDescription
        self.hardSelectButton.setTitle(Strings.select, for: .normal)
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func eazyButtonPressed(_ sender: Any) {
        self.goalType = .eazy
        UserDefaultsProvider.shared.goal = self.goalType?.rawValue
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func mediumButtonPressed(_ sender: Any) {
        self.goalType = .medium
        UserDefaultsProvider.shared.goal = self.goalType?.rawValue
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hardButtonPressed(_ sender: Any) {
        self.goalType = .hard
        UserDefaultsProvider.shared.goal = self.goalType?.rawValue
        self.dismiss(animated: true, completion: nil)
    }
    
}
