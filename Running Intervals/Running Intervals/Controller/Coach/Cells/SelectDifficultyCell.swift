//
//  SelectDifficultyCell.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 05/07/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit

class SelectDifficultyCell: UITableViewCell {

    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setCornerRadius()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setCornerRadius() {
        self.containerView.layer.cornerRadius = self.containerView.bounds.height / 2
    }

}
