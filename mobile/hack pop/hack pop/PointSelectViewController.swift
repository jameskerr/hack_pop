//
//  PointSelectViewController.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/14/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK


class PointSelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pointSelectionLabel: UILabel!
    @IBOutlet weak var notifyThresholdView: UIControl!
    
    public let notifyThresholdAnimator = NotifyThresholdAnimationTransition()
    public let pointRetainer = PointsRetainer.instance()
    
    // set to portrait mode always
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.portrait.rawValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Flurry.logEvent("opened point selection view controller")
        
        view.layer.borderColor = UIColor.clear.cgColor
        
        tableView.backgroundColor = UIColor.clear
        tableView.contentInset = UIEdgeInsetsMake(0, -10, 0, 0);
        let attributedString = HackPopStyle.UnderlinedText("\(pointRetainer.value) Points", fontSize: 18)
        pointSelectionLabel.attributedText = attributedString
        notifyThresholdAnimator.presenting = .close
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return pointRetainer.pointSelectionValues.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPointThreshold = (pointRetainer.pointSelectionValues.object(at: (indexPath as NSIndexPath).row)  as? Int)!
        let attributedString = HackPopStyle.UnderlinedText("\(selectedPointThreshold) Points", fontSize: 18)
        pointSelectionLabel.attributedText = attributedString
        Flurry.logEvent("changed point treshold from \(pointRetainer.value) to \(selectedPointThreshold)")
        close(withRequestToServer:true, threshold:selectedPointThreshold)
    }
    
    @IBAction func closePointSelection(_ sender: AnyObject) {
        Flurry.logEvent("closed change threshold without changing threshold")
        close(withRequestToServer:false, threshold: pointRetainer.value)
    }
    
    func close(withRequestToServer:Bool, threshold:Int) {
        let homeViewController =  storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeViewController.transitioningDelegate = notifyThresholdAnimator
        if (withRequestToServer) {
                //set the delegate to the new view controller
            let clientToken = Client.instance().token
            
            let madeRequest = HackPopServer.setTheshold(id:clientToken,
                                         threshold: threshold,
                                         delegate: homeViewController as HttpSetThresholdListener)
            if madeRequest {
                pointRetainer.value = threshold
            }
            present(homeViewController, animated: true, completion: {
                if !madeRequest {
                    let alert = HackPopStyle.CreateAlertMessage(title: "Could Not Set Points Theshold",
                                                                message: "Your client has not been set yet. Please restart Hacker News Alerts while connected to the internet with notifications enabled.")
                    homeViewController.present(alert, animated:true, completion: nil)
                }
            })
            
        } else {
            present(homeViewController, animated: true, completion: nil)
        }
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pointValue = pointRetainer.pointSelectionValues.object(at: (indexPath as NSIndexPath).row)
        return HackPopStyle.GetStyledPointSelectionCell(pointValue as AnyObject);
    }
}
