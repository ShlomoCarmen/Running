//
//  SelectWeekCell.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 05/07/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit

class SelectWeekCell: UITableViewCell {

    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setCornerRadius()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setCornerRadius() {
        self.containerView.layer.cornerRadius = self.containerView.bounds.height / 2
        self.firstView.layer.cornerRadius = self.firstView.bounds.height / 2
        self.secondView.layer.cornerRadius = self.secondView.bounds.height / 2
        self.thirdView.layer.cornerRadius = self.thirdView.bounds.height / 2
    }

}
