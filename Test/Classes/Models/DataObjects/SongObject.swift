//
//  SongObject.swift
//  Test
//
//  Created by Le Thi An on 12/7/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import Foundation

class SongObject: NSObject, Mappable {
    
    var name: String?
    var artist: String?
    var avatar_imgs:[Avatar]! = []
    var wvlink: String?
    var isFavorite: Bool = false
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name    <- map["im:name.label"]
        artist  <- map["im:artist.label"]
        avatar_imgs  <- map["im:image"]
        wvlink <- map["im:collection.link.attributes.href"]
    }
    
    
    
}

class SongList: NSObject, Mappable {
    
    var songs:[SongObject]! = []
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        songs    <- map["feed.entry"]
    }
}
