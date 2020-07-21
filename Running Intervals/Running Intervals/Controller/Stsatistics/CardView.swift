//
//  CardView.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 21/07/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit
import MapKit

class CardView: UIView {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cardView: UIView!
    
    
    //========================================
    // MARK: - LifeCycle
    //========================================
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetup()
        
    }
    
    override func awakeFromNib() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.xibSetup()
        
    }
    
    // Our custom view from the XIB file
    var view: UIView!
    
    func xibSetup() {
        self.view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        self.view.frame = bounds
        
        // Make the view stretch with containing view
        self.view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        self.addSubview(view)
        self.backgroundColor = .clear
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib:UINib = UINib(nibName: "CardView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func setCornerRadius() {
        self.cardView.layer.cornerRadius = 25
        self.cardView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.cardView.layer.borderWidth = 1
    }
    
    func setShadow() {
        let color = #colorLiteral(red: 0.157, green: 0.166, blue: 0.393, alpha: 0.2)
        Utils.dropViewShadow(view: self.cardView, shadowColor: color, shadowRadius: 14, shadowOffset: CGSize(width: 0, height: 14))
    }
}
