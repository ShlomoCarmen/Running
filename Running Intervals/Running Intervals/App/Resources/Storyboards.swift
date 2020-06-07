//
//  Storyboards.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 02/06/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit

class Storyboards {
    
    class Music {
        private class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
        
        class var  mainViewController: MainViewController {
            return self.mainStoryboard().instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        }
        
    }
}
