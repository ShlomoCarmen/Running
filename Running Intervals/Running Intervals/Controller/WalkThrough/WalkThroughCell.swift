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
            
//            self.textLabel.text = Strings.walkthrough1Text
        case 1:
            self.titleLabel.text = "Prsonal Info"
//            self.textLabel.text = Strings.walkthrough2Text
        case 2:
            self.titleLabel.text = "Goal"
//            self.textLabel.text = Strings.walkthrough3Text
        default:
            break
        }
    }
}
