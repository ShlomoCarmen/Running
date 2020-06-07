//
//  CoachRunViewController.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 04/06/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit

class CoachRunViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var distanceButton: UIButton!
    
    var isTimeMode: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setText()
        self.setCornerRadius()
    }
    
    func setText() {
        self.headerLabel.text = "Start Running"
        self.titleLabel.text = "בחר איזה סוג של אימון אתה רוצה"
        self.timeButton.setTitle("לפי זמן", for: .normal)
        self.distanceButton.setTitle("לפי מרחק", for: .normal)
    }
    
    func setCornerRadius() {
        
        self.timeButton.layer.cornerRadius = self.timeButton.bounds.height / 2
        self.timeButton.layer.borderWidth = 2
        self.timeButton.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        
        self.distanceButton.layer.cornerRadius = self.distanceButton.bounds.height / 2
        self.distanceButton.layer.borderWidth = 2
        self.distanceButton.layer.borderColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func timeButtonPressed(_ sender: Any) {
        self.isTimeMode = true
        self.timeButton.backgroundColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        self.timeButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        
        self.distanceButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.distanceButton.setTitleColor(#colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1), for: .normal)
    }
    
    @IBAction func distanceButtonPressed(_ sender: Any) {
        self.isTimeMode = false
        
        self.distanceButton.backgroundColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
        self.distanceButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
        self.timeButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.timeButton.setTitleColor(#colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1), for: .normal)
    }
    
    
}
