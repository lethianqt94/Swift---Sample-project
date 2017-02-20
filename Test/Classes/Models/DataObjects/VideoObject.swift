//
//  VideoObject.swift
//  Test
//
//  Created by Le Thi An on 12/8/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import Foundation

class VideoObject:NSObject, Mappable {
    
    var title: String?
    var duration:[Duration]! = []
    var cover_imgs:[Avatar]! = []
    var artist:String?
    var vid_name:String?
    var wvlink:String?
    var isFavorite: Bool = false
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        title    <- map["title.label"]
        duration  <- map["link"]
        cover_imgs  <- map["im:image"]
        artist <- map["im:artist.label"]
        vid_name <- map["im:name.label"]
        wvlink <- map["im:artist.attributes.href"]
    }
}

class VideoList: NSObject, Mappable {
    
    var videos:[VideoObject]! = []
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        videos    <- map["feed.entry"]
    }
}