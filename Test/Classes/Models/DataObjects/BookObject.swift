//
//  BookObject.swift
//  Test
//
//  Created by Le Thi An on 12/15/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import Foundation

class BookObject: NSObject, Mappable {
    
    var name: String?
    var author: String?
    var avatar_imgs:[Avatar]! = []
    var wvlink: String?
    var isFavorite: Bool = false
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name    <- map["im:name.label"]
        author  <- map["im:artist.label"]
        avatar_imgs  <- map["im:image"]
        wvlink <- map["link.attributes.href"]
    }
    
    
    
}

class BookList: NSObject, Mappable {
    
    var books:[BookObject]! = []
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        books    <- map["feed.entry"]
    }
}
