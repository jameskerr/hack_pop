//
//  RecentStoriesTransitionViewController.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/28/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import Foundation
import UIKit

class RecentStoriesTransitionViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var index = 1
    var identifiers = ["RecentStoriesViewController", "HomeViewController", "WebViewController"]
    override func viewDidLoad() {
        
        self.dataSource = self
        self.delegate = self
        
        let startingViewController = self.viewControllerAtIndex(index: self.index)
        let viewControllers: NSArray = [startingViewController]
        self.setViewControllers(viewControllers as? [UIViewController], direction: .forward, animated: false, completion: nil)
        
        
        
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController! {
        if index < identifiers.count {
            return self.storyboard!.instantiateViewController(withIdentifier: identifiers[index]) 
        }
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let identifier = viewController.restorationIdentifier! as String
        let index = self.identifiers.index(of: identifier)
        
        //if the index is the end of the array, return nil since we dont want a view controller after the last one
        if index == identifiers.count - 1 {
            
            return nil
        }
        
        //increment the index to get the viewController after the current index
        self.index = self.index + 1
        return self.viewControllerAtIndex(index: self.index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let identifier = viewController.restorationIdentifier! as String
        let index = self.identifiers.index(of: identifier)
        
        //if the index is 0, return nil since we dont want a view controller before the first one
        if index == 0 {
            
            return nil
        }
        
        //decrement the index to get the viewController before the current one
        self.index = self.index - 1
        return self.viewControllerAtIndex(index: self.index)
        
    }
    
    
    private func presentationCountForPageViewController(pageViewController: UIPageViewController!) -> Int {
        return self.identifiers.count - 1
    }
    
    private func presentationIndexForPageViewController(pageViewController: UIPageViewController!) -> Int {
        return 0
    }
    
}


