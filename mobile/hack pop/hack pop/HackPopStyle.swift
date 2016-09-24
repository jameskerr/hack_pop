//
//  HackPopButtonStyle.swift
//  hack pop
//
//  Created by Jamie Sunderland on 9/20/16.
//  Copyright © 2016 james inc. All rights reserved.
//

import UIKit

class HackPopStyle: NSObject {
    
    static let pointRetainer = PointsRetainer.instance()

    static func UnderlinedText(_ string:String, fontSize:CGFloat) -> NSAttributedString {
        return NSAttributedString(string: string,
                                  attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue,
                                    NSFontAttributeName:UIFont(name: "Raleway", size: fontSize)!,
                                    NSForegroundColorAttributeName:UIColor.white])
    }
    
    static func NormalText(_ string:String, fontSize:CGFloat) -> NSAttributedString {
        return NSAttributedString(string: string,
                                  attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleNone.rawValue,
                                    NSFontAttributeName:UIFont(name: "Raleway", size: fontSize)!,
                                    NSForegroundColorAttributeName:UIColor.white])
    }
    
    static func GetStyledPointSelectionCell(_ pointValue:AnyObject) -> UITableViewCell {
        
        let pointValueInt:Int = pointValue as! Int
        let id:String? = String(describing: pointValue)
        let cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: id)
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        cell.textLabel?.attributedText = (pointValueInt == pointRetainer.value) ?
                UnderlinedText("\(id!) Points", fontSize: 18) :
                NormalText("\(id!) Points", fontSize: 18)
        return cell
    
    }
    
    static func GetStyledStoryCell(_ story:Story) -> UITableViewCell {
        
        let text = "(\(story.points!)) \(story.title!)"
        let cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: story.url?.absoluteString)
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        cell.textLabel?.attributedText = UnderlinedText(text, fontSize: 18)
        cell.textLabel?.numberOfLines = 4
        cell.textLabel?.layoutMargins = UIEdgeInsetsMake(30, 0, 30, 0);
        return cell
        
    }
    
    static func StyleTopStoriesTableView(tableView:UITableView) {
    
        tableView.backgroundColor = UIColor.clear
        tableView.contentInset = UIEdgeInsetsMake(-20, -15, 0, 0);
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
}
