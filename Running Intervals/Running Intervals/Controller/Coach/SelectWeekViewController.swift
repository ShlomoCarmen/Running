//
//  SelectWeekViewController.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 04/06/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class SelectWeekViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var changePlanButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var weeks: Int?
    var currentWeek: Int?
    var training: [Training] = []
    var goalType: GoalType?
    var allRuns: [Run] = []
    var goal: String = ""
    
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

        self.getRuns()
    }
    
    func setWeeks() {
        switch self.goalType {
        case .eazy:
            self.weeks = 8
            self.goal = "1"
        case .medium:
            self.weeks = 14
            self.goal = "2"
        case .hard:
            self.weeks = 18
            self.goal = "3"
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
    
    func navigateToSelectTraining(_ week: Int) {
        self.performSegue(withIdentifier: "showSelectTraining", sender: week)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSelectTraining" {
            let selectTrainingVC = segue.destination as! SelectTrainingViewController
            selectTrainingVC.weekNumber = sender as? Int
            selectTrainingVC.goalType = self.goalType
            selectTrainingVC.goal = self.goal
        }
    }
    
    func getRuns() {
        let request: NSFetchRequest<Run> = Run.fetchRequest()
        do {
            let result = try CoreDataManager.context.fetch(request)
            self.allRuns = result
            self.tableView.reloadData()
        } catch {
            print("Failed")
        }
    }
    
    func getCompletedSessions(_ goal: String, _ week: String) -> Int {
        var counter = Set<String>()
        for run in self.allRuns {
            guard let sessionIdArr = run.sessionId?.components(separatedBy: "_") else { return 0 }
            if sessionIdArr[0] == goal && sessionIdArr[1] == week {
                counter.insert(sessionIdArr[2])
            }
        }
        return counter.count
    }
    
}

extension SelectWeekViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let weeks = self.weeks {
            return weeks
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectDifficultyCell", for: indexPath) as! SelectWeekCell
        let index = indexPath.row + 1
        cell.weekLabel.text = "\(Strings.week) \(index)"
        
        let completed = self.getCompletedSessions(self.goal, "\(index)")

        if completed == 1 {
            cell.firstView.isHidden = false
            cell.secondView.isHidden = true
            cell.thirdView.isHidden = true
        } else if completed == 2 {
            cell.firstView.isHidden = false
            cell.secondView.isHidden = false
            cell.thirdView.isHidden = true
        } else if completed == 3 {
            cell.firstView.isHidden = false
            cell.secondView.isHidden = false
            cell.thirdView.isHidden = false
        } else {
            cell.firstView.isHidden = true
            cell.secondView.isHidden = true
            cell.thirdView.isHidden = true
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row + 1
        self.navigateToSelectTraining(index)

    }
    
}
