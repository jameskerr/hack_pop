//
//  HomeViewController.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/14/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, HttpStoriesListener, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleViewContainer: UIStackView!
    @IBOutlet weak var notifyViewContainer: UIStackView!
    @IBOutlet weak var topStoriesContainerView: UIStackView!
    @IBOutlet weak var topStoriesTable: UITableView!
    @IBOutlet weak var topStoriesLabel: UILabel!
    @IBOutlet weak var storyThresholdButton: UIButton!
    
    let pointRetainer = PointsRetainer.instance()
    let hackPopServer = HackPopServer.instance()
    var stories:[Story]? = nil
    var filteredStories:[Story]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributedString = HackPopStyle.UnderlinedText("\(pointRetainer.value) Points", fontSize: 18)
        HackPopStyle.StyleTopStoriesTableView(tableView: topStoriesTable)
        storyThresholdButton.setAttributedTitle(attributedString, for: UIControlState())
        topStoriesLabel.text = "Stories Over \(pointRetainer.value) Points"
        hackPopServer.getStories(delegate: self)
        
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
    
    @IBAction func openHackerNews(_ sender: AnyObject) {
        let hackerNewsStory = Story(url: "https://news.ycombinator.com/", title: "", points: 0);
        Story.current = hackerNewsStory
        performSegue(withIdentifier:"openWebView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue is PointSelectionSegue {
            (segue as! PointSelectionSegue).animationType = .openPointSelection
        }        
    }
    
    func onStoriesLoaded(stories: [Story]) {
        self.stories = stories
        DispatchQueue.main.async {
            self.topStoriesTable.reloadData()
        }
    }
    
    func onStoriesLoadedError(error: Error) {
       //switch on error handling
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        if let currentStories = self.stories {
            filteredStories = currentStories.filter({$0.meetsThreshold(threshold: pointRetainer.value)})
            return filteredStories!.count
        }
        filteredStories = nil
        //show no stories view
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let story = filteredStories?[(indexPath as NSIndexPath).row]
        return HackPopStyle.GetStyledStoryCell(story!);
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = filteredStories?[(indexPath as NSIndexPath).row]
        Story.current = story
        performSegue(withIdentifier:"openWebView", sender: nil)
    }
}

