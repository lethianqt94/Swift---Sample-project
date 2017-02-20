//
//  CommonColor.swift
//  Test
//
//  Created by Le Thi An on 12/22/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int)
    {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}


//UIColors


let RED_FF5722 = UIColor(red: 255, green: 87, blue: 34)

let BLACK_585858 = UIColor(red: 88, green: 88, blue: 88)

let BLACK_212121 = UIColor(red: 33, green: 33, blue: 33)

let BLACK_727272 = UIColor(red: 114, green: 114, blue: 114)

let GREEN_4CAF50 = UIColor(red: 76, green: 175, blue: 80)

let GREEN_358538 = UIColor(red: 53, green: 133, blue: 56)

let GRAY_B6B6B6 = UIColor(red: 182, green: 182, blue: 182)

let GRAY_9B9B9B = UIColor(red: 155, green: 155, blue: 155)

let GRAY_ABABAB = UIColor(red: 171, green: 171, blue: 171)

let GRAY_E1E1E1 = UIColor(red: 225, green: 225, blue: 225)

let GRAY_979797 = UIColor(red: 151, green: 151, blue: 151)

let BLUE_0E63C7 = UIColor(red: 14, green: 99, blue: 199)

//Fonts

let HelveticaNeueBold14 = UIFont(name: "HelveticaNeue-Bold", size: 14)

let ProximaNovaSemibold13 = UIFont(name: "ProximaNova-Semibold", size: 13.0)

let ProximaNovaSemibold12 = UIFont(name: "ProximaNova-Semibold", size: 12.0)

let ProximaNovaSemibold16 = UIFont(name: "ProximaNova-Semibold", size: 16.0)

let ProximaNovaSemibold15 = UIFont(name: "ProximaNova-Semibold", size: 15.0)

let ProximaNovaRegular145 = UIFont(name: "ProximaNova-Regular", size: 14.5)

let ProximaNovaRegular14 = UIFont(name: "ProximaNova-Regular", size: 14.0)

let ProximaNovaRegular15 = UIFont(name: "ProximaNova-Regular", size: 15.0)

let ProximaNovaThin22 = UIFont(name: "ProximaNovaThin", size: 22.0)

let ProximaNovaSemibold145 = UIFont(name: "ProximaNova-Semibold", size: 14.5)

let ProximaNovaSemibold14 = UIFont(name: "ProximaNova-Semibold", size: 14.0)






