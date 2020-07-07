//
//  SelectSongCell.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 26/05/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit

class SelectSongCell: UITableViewCell {

    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var durationLable: UILabel!
    
    @IBOutlet weak var slowSongSelectedButton: UIButton!
    @IBOutlet weak var fastSongSelectedButton: UIButton!
    
    var songSelected: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cornerRadius()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func cornerRadius() {
        self.fastSongSelectedButton.layer.cornerRadius = self.fastSongSelectedButton.bounds.height / 2
        self.fastSongSelectedButton.layer.borderWidth = 1
        self.fastSongSelectedButton.layer.borderColor = #colorLiteral(red: 0.4091816725, green: 0.5505421041, blue: 0.7803921569, alpha: 1)
        self.slowSongSelectedButton.layer.cornerRadius = self.slowSongSelectedButton.bounds.height / 2
        self.slowSongSelectedButton.layer.borderWidth = 1
        self.slowSongSelectedButton.layer.borderColor = #colorLiteral(red: 0.9072619132, green: 0.6691572433, blue: 0.9029235371, alpha: 1)
    }
}
