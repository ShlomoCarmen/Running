//
//  WalkThroughCell.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 23/07/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit

class WalkThroughCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var imageViews: [UIImageView]!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    
    func setIndex(_ index: Int) {
        self.setTitle(index)
        self.imageViews.forEach{$0.isHidden = $0.tag != index}
    }
    
    private func setTitle(_ index: Int) {
        switch index {
        case 0:
            self.titleLabel.text = "Music"
            self.selectButton.setTitle(Strings.selectMusic, for: .normal)
        case 1:
            self.titleLabel.text = "Prsonal Info"
            self.selectButton.setTitle(Strings.personalInformaition, for: .normal)
        case 2:
            self.titleLabel.text = "Goal"
            self.selectButton.setTitle(Strings.goalTitle, for: .normal)

        default:
            break
        }
    }
    
    func setCornerRadius() {
        self.selectButton.layer.cornerRadius = self.selectButton.bounds.height / 2
        self.selectButton.layer.borderWidth = 2
        self.selectButton.layer.borderColor = #colorLiteral(red: 0.2115887702, green: 0.4200505018, blue: 0.7173388004, alpha: 1)
    }
}
