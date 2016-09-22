//
//  PointSelectViewController.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/14/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit


class PointSelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pointSelectionCloseButton: UIButton!

    let pointRetainer = PointsRetainer.instance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.clear
        tableView.contentInset = UIEdgeInsetsMake(0, -15, 0, 0);
        let attributedString = HackPopStyle.UnderlinedText("\(pointRetainer.value) Points", fontSize: 18)
        pointSelectionCloseButton.setAttributedTitle(attributedString, for: UIControlState())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.portrait.rawValue)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue is PointSelectionSegue {
            (segue as! PointSelectionSegue).animationType = .closePointSelection
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return pointRetainer.pointSelectionValues.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pointRetainer.value = (pointRetainer.pointSelectionValues.object(at: (indexPath as NSIndexPath).row)  as? Int)!
        let attributedString = HackPopStyle.UnderlinedText("\(pointRetainer.value) Points", fontSize: 18)
        pointSelectionCloseButton.setAttributedTitle(attributedString, for: UIControlState())
        performSegue(withIdentifier: PointSelectionSegue.SegueId, sender: nil)
    }
    
    @IBAction func closePointSelection(_ sender: AnyObject) {
        performSegue(withIdentifier: PointSelectionSegue.SegueId, sender: nil)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pointValue = pointRetainer.pointSelectionValues.object(at: (indexPath as NSIndexPath).row)
        return HackPopStyle.GetStyledPointSelectionCell(pointValue as AnyObject);
    
    }
}
