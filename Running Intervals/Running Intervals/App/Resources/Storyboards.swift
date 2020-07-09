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
        
        class var  musicViewController: MyMusicViewController {
            return self.mainStoryboard().instantiateViewController(withIdentifier: "MyMusicViewController") as! MyMusicViewController
        }
    }
    
    class Settings {
        private class func settingsStoryboard() -> UIStoryboard { return UIStoryboard(name: "Settings", bundle: Bundle.main) }
        
        class var  goalViewController: CoachGoalViewController {
            return self.settingsStoryboard().instantiateViewController(withIdentifier: "CoachGoalViewController") as! CoachGoalViewController
        }
        
        class var  personalInformationViewController: PersonalInformationViewController {
            return self.settingsStoryboard().instantiateViewController(withIdentifier: "PersonalInformationViewController") as! PersonalInformationViewController
        }
    }
}
