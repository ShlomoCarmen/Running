//
//  WalkThroughViewController.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 23/07/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit
import MediaPlayer

class WalkThroughViewController: UIViewController {

    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var pageControl: UIPageControl!
    
    let allMediaItems = MPMediaQuery.songs().items
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @objc func selectButtonPreesed(_ button: UIButton) {
        if button.tag == 0 {
            self.presentSelectMusic()
        } else if button.tag == 1 {
            self.presentPersonalInformation()
        } else {
            self.presentGoal()
        }
    }
    
    func navigateToMain() {
        let mainViewController = Storyboards.Main.mainViewController
        appDelegate.setRootViewController(viewController: mainViewController, animated: true)
    }
    
    func presentSelectMusic() {
        let selectMusicViewController = Storyboards.Main.selectMusicViewController
        self.present(selectMusicViewController, animated: true, completion: nil)
    }
    
    func presentGoal() {
        let goalViewController = Storyboards.Settings.goalViewController
        self.present(goalViewController, animated: true, completion: nil)
    }
    
    func presentPersonalInformation() {
        let personalInformationViewController = Storyboards.Settings.personalInformationViewController
        self.present(personalInformationViewController, animated: true, completion: nil)
    }
    

}

extension WalkThroughViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "walkThroughCell", for: indexPath) as? WalkThroughCell
        else {
            return UICollectionViewCell()
        }
        cell.setIndex(indexPath.item)
        cell.setCornerRadius()
        cell.selectButton.tag = indexPath.item
        cell.selectButton.addTarget(self, action: #selector(self.selectButtonPreesed(_:)), for: .touchUpInside)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.contentOffset.x < scrollView.bounds.width*0.5 {
            self.pageControl.currentPage = 0
        }
        else if scrollView.contentOffset.x < scrollView.bounds.width*1.5 {
            self.pageControl.currentPage = 1
        }
        else if scrollView.contentOffset.x < scrollView.bounds.width*2.5 {
            self.pageControl.currentPage = 2
        }
        
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if UserDefaultsProvider.shared.appLanguageCode == "he-IL" {
            if scrollView.contentOffset.x < 0 {
                UserDefaultsProvider.shared.seenWalkThrough = true
                self.navigateToMain()
            }
        } else {
            if scrollView.contentOffset.x > scrollView.bounds.width * 2 {
                UserDefaultsProvider.shared.seenWalkThrough = true
                self.navigateToMain()
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
