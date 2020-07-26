//
//  Storyboards.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 02/06/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit

class Storyboards {
    
    class WalkThrough {
        private class func walkThroughStoryboard() -> UIStoryboard { return UIStoryboard(name: "WalkThrough", bundle: Bundle.main) }
        
        class var  walkThroughViewController: WalkThroughViewController {
            return self.walkThroughStoryboard().instantiateViewController(withIdentifier: "WalkThroughViewController") as! WalkThroughViewController
        }
    }
    
    class Main {
        private class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
        
        class var  mainViewController: MainViewController {
            return self.mainStoryboard().instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        }
        
        class var  musicViewController: MyMusicViewController {
            return self.mainStoryboard().instantiateViewController(withIdentifier: "MyMusicViewController") as! MyMusicViewController
        }
        
        class var  selectMusicViewController: SelectMusicViewController {
            return self.mainStoryboard().instantiateViewController(withIdentifier: "SelectMusicViewController") as! SelectMusicViewController
        }
    }
    
    class Settings {
        private class func settingsStoryboard() -> UIStoryboard { return UIStoryboard(name: "Settings", bundle: Bundle.main) }
        
        class var  goalViewController: SelectGoalViewController {
            return self.settingsStoryboard().instantiateViewController(withIdentifier: "CoachGoalViewController") as! SelectGoalViewController
        }
        
        class var  personalInformationViewController: PersonalInformationViewController {
            return self.settingsStoryboard().instantiateViewController(withIdentifier: "PersonalInformationViewController") as! PersonalInformationViewController
        }
    }
}
