//
//  Common.swift
//  Test
//
//  Created by Le Thi An on 12/22/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import Foundation
import UIKit

class Common {
    
    class func dateDiff(origDate: NSDate) -> String {
        var ti = origDate.timeIntervalSinceNow
        var diff = 0
        ti = ti * -1;
        if(ti < 1) {
            return "few seconds ago"
        } else if (ti < 60) {
            return "less than a minute ago"
        } else if (ti < 3600) {
            diff = Int(ti / 60);
            if (diff == 1) {
                return "a minute ago"
            } else {
                return String(diff) + " minutes ago"
            }
        } else if (ti < 86400) {
            diff = Int(ti / 60 / 60)
            if (diff == 1) {
                return "an hour ago"
            } else {
                return String(diff) + " hours ago"
            }
        } else {
            diff = Int(ti / 60 / 60 / 24)
            if (diff == 1) {
                return "a day ago"
            } else {
                if (diff < 7) {
                    return String(diff) + " days ago"
                } else if (diff == 7){
                    return "a week ago"
                } else if (diff > 7 && diff < 30){
                    if (Int(diff/7) == 1) {
                        return "more than a week ago"
                    } else {
                        if (diff%7 == 0) {
                            return String(Int(diff/7)) + " weeks ago"
                        } else {
                            return "more than " + String(Int(diff/7)) + " weeks ago"
                        }
                    }
                } else if (diff == 30) {
                    return "one month ago"
                } else if (diff > 30 && diff < 365) {
                    if (Int(diff)/30 == 1) {
                        return "more than one month ago"
                    } else {
                        if (diff%30 == 0) {
                            return String(Int(diff/30)) + " months ago"
                        } else {
                            return "more than " + String(Int(diff/30)) + " months ago"
                        }
                    }
                } else if (diff == 365) {
                    return "one year ago"
                } else {
                    if (Int(diff/365) == 1) {
                        return "more than one year ago"
                    } else {
                        if (diff%365 == 0) {
                            return String(Int(diff/365)) + " years ago"
                        } else {
                            return "more than " + String(Int(diff/365)) + " years ago"
                        }
                    }
                }
            }
        }
    }
    
    class func isTextOutOfBound(label: UILabel, str: String) -> Bool {
        let fontName = label.font.fontName
        let fontSize = label.font.pointSize
        let font = UIFont(name: fontName, size: fontSize)
        
        let size: CGSize = str.sizeWithAttributes([NSFontAttributeName: font!])
        //        print(heightForView(str, font: font!, width: label.frame.size.width)/size.height - 1)
        if (heightForView(str, font: font!, width: label.frame.size.width)/size.height - 1 > 3) {
            return true
        } else {
            return false
        }
        
    }
    
    class func countMacChars(label: UILabel) -> Int{
        let fontName = label.font.fontName
        let fontSize = label.font.pointSize
        let font = UIFont(name: fontName, size: fontSize)
        
        let sizeALetter: CGSize = " ".sizeWithAttributes([NSFontAttributeName: font!])
        
        return Int(label.frame.size.width*3/sizeALetter.width)
    }
    
    class func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    class func checkDescriptionLength(text: String, max:Int) -> String {
        
        let nsText:NSString = text
        var sub: String
        
        if(nsText.length > max) {
            
            sub = nsText.substringWithRange(NSRange(location: 0, length: max-9))
            
            return sub + "read more"
        } else {
            return text
        }
    }
    
    class func removeChar(text: String, label : UILabel) -> String {
        var result = text
        
        
        if(isTextOutOfBound(label, str: result)) {
            
            repeat {
                result.removeAtIndex(result.startIndex.advancedBy(result.characters.count - 10))
            } while (isTextOutOfBound(label, str: result))
            let char = NSString(string: result).substringWithRange(NSRange(location: result.characters.count - 10, length: 1))
            if (char != " ") {
                result = (result as NSString).stringByReplacingCharactersInRange(NSRange(location: result.characters.count - 10, length: 1), withString: " ")
            }
            
        }
        
        //        print(result)
        return result
    }
    
    class func removeBreakLine(text: String) -> String {
        
        var nsText:NSString = text
        
        nsText = nsText.stringByReplacingOccurrencesOfString("\n", withString: "")
        nsText = nsText.stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet())
        
        return String(nsText)
    }

    
    
}