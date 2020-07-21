//
//  HistoryViewController.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 20/07/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var allRuns: [Run] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setText()
        self.getRuns()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func setText() {
        self.titleLabel.text = Strings.history
        self.backButton.setTitle(Strings.back, for: .normal)
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
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentStatistics" {
            let statisticsVC = segue.destination as! LastRunViewController
            statisticsVC.run = sender as? Run
        }
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allRuns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
        let run = self.allRuns[indexPath.row]
        let formattedDate = FormatDisplay.date(run.timestamp)
        let seconds = Int(run.duration)
        let formattedTime = FormatDisplay.time(seconds)
        let distance = Measurement(value: run.distance, unit: UnitLength.meters)
        let formattedPace = FormatDisplay.pace(distance: distance, seconds: seconds, outputUnit: UnitSpeed.kilometersPerHour)
        
        cell.dateLabel.text = formattedDate
        cell.timeLabel.text = formattedTime
        cell.distanceLabel.text = "\(Int(distance.value))"
        cell.speedLabel.text = formattedPace
        cell.caloriesLabel.text = run.calories
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let run = self.allRuns[indexPath.row]
        self.performSegue(withIdentifier: "presentStatistics", sender: run)
    }
    
    
}
