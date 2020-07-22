//
//  SelectTrainingViewController.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 14/07/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit
import CoreData

class SelectTrainingViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    
    var goalType: GoalType?
    var weekNumber: Int?
    var trainingNumber: Int?
    var training: [Training]?
    var allRuns: [Run] = []
    var goal: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.training = TrainingRepository.shared.getAllTraining()
        
        self.setText()
        self.setCornerRadius()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getRuns()
    }
    
    func setText() {
        self.backButton.setTitle(Strings.back, for: .normal)
        self.headerLabel.text = Strings.selectTrainingTitle
        self.firstButton.setTitle("\(Strings.trainingNumber) 1", for: .normal)
        self.secondButton.setTitle("\(Strings.trainingNumber) 2", for: .normal)
        self.thirdButton.setTitle("\(Strings.trainingNumber) 3", for: .normal)
    }
    
    func setCornerRadius() {
        self.firstButton.layer.cornerRadius = self.firstButton.bounds.height / 2
        self.secondButton.layer.cornerRadius = self.secondButton.bounds.height / 2
        self.thirdButton.layer.cornerRadius = self.thirdButton.bounds.height / 2
    }
    
    func getRuns() {
        let request: NSFetchRequest<Run> = Run.fetchRequest()
        do {
            let result = try CoreDataManager.context.fetch(request)
            self.allRuns = result
            self.setButtons(firstButton, 1)
            self.setButtons(secondButton, 2)
            self.setButtons(thirdButton, 3)

        } catch {
            print("Failed")
        }
    }
   
    func setButtons(_ button: UIButton, _ trainingNumber: Int) {
        guard let weekNumber = self.weekNumber else { return }
        let sessionId = "\(goal)_\(weekNumber)_\(trainingNumber)"
        for run in self.allRuns {
            if run.sessionId == sessionId {
                button.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func firstButtonPressed(_ sender: Any) {
        self.trainingNumber = 1
        self.presentRunViewController()
    }
    
    @IBAction func secondButtonPressed(_ sender: Any) {
        self.trainingNumber = 2
        self.presentRunViewController()
    }
    
    @IBAction func thirdButtonPressed(_ sender: Any) {
        self.trainingNumber = 3
        self.presentRunViewController()
    }
    
    // MARK: Navigation
    
    func presentRunViewController() {
        self.performSegue(withIdentifier: "showRun", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRun" {
            let runVC = segue.destination as! CoachRunViewController
            runVC.goalType = self.goalType
            runVC.weekNumber = self.weekNumber
            runVC.trainingNumber = self.trainingNumber
        }
    }
    
}
