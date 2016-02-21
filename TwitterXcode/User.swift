//
//  User.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/16.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import SwiftyJSON

class User {
    
    var follow_state: Bool = false
    private (set) var user_token: String
    private (set) var user_identifier: String
    private (set) var username: String
    private (set) var icon_image_url: String
    private (set) var following_count: Int = 0
    private (set) var follower_count: Int = 0
    
    init(json:JSON){
        self.user_token = json["user_token"].stringValue
        self.user_identifier = json["user_identifier"].stringValue
        self.username = json["username"].stringValue
        self.icon_image_url = json["icon_image_url"].stringValue
        self.follow_state = self.setFollowState(json)
        self.following_count = json["following_count"].intValue
        self.follower_count = json["follower_count"].intValue
    }
    
    func getUserData() -> [String:String] {
        let userData = [
            "user_token": user_token,
            "user_identifier": user_identifier,
            "username": username,
            "icon_image_url": icon_image_url,
        ]
        return userData
    }
    
    private func setFollowState(json: JSON) -> Bool {
        if json["follow_state"].intValue == 1 {
            return true
        } else if json["follow_state"].intValue == 0 {
            return false
        } else {
            return false
        }
        
    }
    
}
