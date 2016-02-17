//
//  User.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/16.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import SwiftyJSON

class User {
    
    private (set) var user_token: String
    private (set) var user_identifier: String
    private (set) var username: String
    private (set) var icon_image_url: String
    
    init(json:JSON){
        self.user_token = json["user_token"].stringValue
        self.user_identifier = json["user_identifier"].stringValue
        self.username = json["username"].stringValue
        self.icon_image_url = json["icon_image_url"].stringValue
    }
    
    func getUserData() -> [String:String] {
        let userData = ["user_token": user_token,"user_identifier": user_identifier,"username": username,"icon_image_url": icon_image_url]
        return userData
    }
    
}
