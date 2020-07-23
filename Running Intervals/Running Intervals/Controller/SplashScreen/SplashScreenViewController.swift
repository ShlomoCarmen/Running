//
//  SplashScreenViewController.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 23/07/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigation()
    }
    
    func navigation() {
        if UserDefaultsProvider.shared.seenWalkThrough == false {
            self.navigateToWalkThrough()
        } else {
            self.navigateToMain()
        }
    }
    
    func navigateToWalkThrough() {
        let walkThroughViewController = Storyboards.WalkThrough.walkThroughViewController
        appDelegate.setRootViewController(viewController: walkThroughViewController, animated: true)
    }
    
    func navigateToMain() {
        let mainViewController = Storyboards.Main.mainViewController
        appDelegate.setRootViewController(viewController: mainViewController, animated: true)
    }
    
}
