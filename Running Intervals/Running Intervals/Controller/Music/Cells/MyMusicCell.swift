//
//  MyMusicCell.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 31/05/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit

class MyMusicCell: UITableViewCell {
    
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var durationLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
