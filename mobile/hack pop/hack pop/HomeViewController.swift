//
//  HomeViewController.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/14/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var titleViewContainer: UIStackView!
    @IBOutlet weak var notifyViewContainer: UIStackView!
    @IBOutlet weak var topStoriesContainerView: UIStackView!
    @IBOutlet weak var topStoriesTable: UITableView!
    @IBOutlet weak var topStoriesLabel: UILabel!
    @IBOutlet weak var storyThresholdButton: UIButton!
    
    let pointRetainer = PointsRetainer.instance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributedString = HackPopStyle.UnderlinedText("\(pointRetainer.value) Points", fontSize: 18)
        storyThresholdButton.setAttributedTitle(attributedString, for: UIControlState())
        topStoriesLabel.text = "Stories Over \(pointRetainer.value) Points"
        
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.portrait.rawValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
    }
    
    @IBAction func revealPointSelectionVC(_ sender: AnyObject) {
        performSegue(withIdentifier: PointSelectionSegue.SegueId, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue is PointSelectionSegue {
            (segue as! PointSelectionSegue).animationType = .openPointSelection
        }
        
    }
}

