//
//  VideoCoverImage.swift
//  Test
//
//  Created by Le Thi An on 12/14/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import Foundation

class Duration:NSObject, Mappable {
    
    var duration:String! = ""
    
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        duration    <- map["im:duration.label"]
    }
    
}