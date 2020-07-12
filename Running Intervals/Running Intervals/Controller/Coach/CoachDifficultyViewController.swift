//
//  CoachDifficultyViewController.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 04/06/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit

class CoachDifficultyViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var changePlanButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var weeks: Int?
    var currentWeek: Int?
    var training: [Training]?
    var goalType: GoalType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaultsProvider.shared.user == nil {
            self.navigateToPersonal()
            return
        }
        if UserDefaultsProvider.shared.goal == nil {
            self.navigateToGoal()
            return
        }
        self.training = TrainingRepository.shared.getAllTraining()
        self.goalType = GoalType(rawValue: UserDefaultsProvider.shared.goal ?? "")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setText()
        self.setWeeks()
        self.getTraining()
    }
    
    func getTraining() {
        let trainingNumber = UserDefaultsProvider.shared.training - 1
        guard let traning = self.training?[trainingNumber] else { return }
        self.currentWeek = traning.week
        self.tableView.reloadData()
    }
    
    func setWeeks() {
        switch self.goalType {
        case .eazy:
            self.weeks = 8
        case .medium:
            self.weeks = 14
        case .hard:
            self.weeks = 18
        default:
            self.weeks = 0
        }
    }
    
    func setText() {
        self.changePlanButton.setTitle(Strings.changePlane, for: .normal)
        self.backButton.setTitle(Strings.back, for: .normal)
        self.headerLabel.text = Strings.trainingWeek
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changePlanButtonPressed(_ sender: Any) {
        self.navigateToGoal()
    }
    
    // MARK: Navigation
    
    func navigateToPersonal() {
        let personalVC = Storyboards.Settings.personalInformationViewController
        personalVC.modalPresentationStyle = .fullScreen
        self.present(personalVC, animated: true, completion: nil)
        
    }
    
    func navigateToGoal() {
        let goalVC = Storyboards.Settings.goalViewController
        goalVC.modalPresentationStyle = .fullScreen
        self.present(goalVC, animated: true, completion: nil)
        
    }
    
    func navigateToRun(_ week: Int) {
        self.performSegue(withIdentifier: "showRun", sender: week)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRun" {
            let runVC = segue.destination as! CoachRunViewController
            runVC.weekNumber = sender as? Int
        }
    }
    
}

extension CoachDifficultyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let weeks = self.weeks {
            return weeks
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectDifficultyCell", for: indexPath) as! SelectDifficultyCell
        let index = indexPath.row + 1
        cell.weekLabel.text = "\(Strings.week) \(index)"
        if let currentWeek = self.currentWeek {
            if currentWeek == index {
                cell.containerView.backgroundColor = #colorLiteral(red: 0, green: 0.3012604127, blue: 0.6312049279, alpha: 1)
            } else if currentWeek > index {
                cell.containerView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            } else {
                cell.containerView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row + 1
        if let currentWeek = self.currentWeek {
            if index <= currentWeek {
                self.navigateToRun(index)
                
            }
        }
    }
    
}
