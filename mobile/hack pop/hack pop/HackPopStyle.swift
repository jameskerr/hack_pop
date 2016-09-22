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
}
