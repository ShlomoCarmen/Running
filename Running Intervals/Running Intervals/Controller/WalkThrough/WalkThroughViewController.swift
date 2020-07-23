//
//  WalkThroughViewController.swift
//  Running Intervals
//
//  Created by Shlomo Carmen on 23/07/2020.
//  Copyright © 2020 Running. All rights reserved.
//

import UIKit

class WalkThroughViewController: UIViewController {

    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension WalkThroughViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "walkThroughCell", for: indexPath) as? WalkThroughCell
        else {
            return UICollectionViewCell()
        }
//        cell.setIndex
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
    
    
}
