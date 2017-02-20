//
//  NewsObject.swift
//  Test
//
//  Created by Le Thi An on 12/21/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import Foundation

class NewsObject: NSObject, Mappable {
    
    var title: String?
    var content: String?
    var image_link:String?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        title    <- map["titleNoFormatting"]
        content  <- map["content"]
        image_link  <- map["image.url"]
    }
    
    
    
}

class NewsList: NSObject, Mappable {
    
    var list:[NewsObject]! = []
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        list    <- map["responseData.results"]
    }
}