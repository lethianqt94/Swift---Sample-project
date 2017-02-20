//
//  File.swift
//  Test
//
//  Created by Le Thi An on 12/21/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import Foundation

class WebObject: NSObject, Mappable {
    
    var title: String?
    var content: String?
    var url:String?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        title    <- map["titleNoFormatting"]
        content  <- map["content"]
        url  <- map["url"]
    }
    
    
    
}

class WebList: NSObject, Mappable {
    
    var list:[WebObject]! = []
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        list    <- map["responseData.results"]
    }
}