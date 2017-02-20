//
//  VideoSearchObject.swift
//  Test
//
//  Created by Le Thi An on 12/21/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import Foundation

class VideoSearchObject: NSObject, Mappable {
    
    var title: String?
    var content: String?
    var video_link:String?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        title    <- map["titleNoFormatting"]
        content  <- map["content"]
        video_link  <- map["tbUrl"]
    }
    
    
    
}

class VideoSearchList: NSObject, Mappable {
    
    var list:[VideoSearchObject]! = []
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        list    <- map["responseData.results"]
    }
}