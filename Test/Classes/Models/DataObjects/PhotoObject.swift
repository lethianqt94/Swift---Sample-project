//
//  PhotoObject.swift
//  Test
//
//  Created by Le Thi An on 12/9/15.
//  Copyright © 2015 Le Thi An. All rights reserved.
//

import Foundation

class PhotoObject: NSObject, Mappable {
    
    var avatar_img: String?
    var fullname: String?
    var dateCreated: String?
    var username: String?
    var photo: String?
    var title: String?
    var descriptions: String?
    var likeNum: Double?
    var viewNum: Double?
    var isFavorite: Bool = false
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        fullname    <- map["user.fullname"]
        avatar_img  <- map["user.avatars.default.https"]
        username  <- map["user.username"]
        descriptions <- map["description"]
        photo <- map["image_url"]
        title <- map["name"]
        viewNum <- map["times_viewed"]
        likeNum <- map["votes_count"]
        dateCreated <- map["created_at"]
    }

}

class PhotoList: NSObject, Mappable {
    
//    var current_page:Int?
    var photos:[PhotoObject]! = []
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        photos    <- map["photos"]
//        current_page <- map["current_page"]
    }
}


