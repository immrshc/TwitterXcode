//
//  TimeLine.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/16.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import SwiftyJSON

class TimeLine {
    
    private (set) var postToken:String?
    private (set) var favoriteCheck:Bool = false
    private (set) var favoriteCount:Int = 0
    private (set) var username:String?
    private (set) var userIconURL:String?
    private (set) var text:String?
    private (set) var imageURL:String?
    private (set) var latitude:Double?
    private (set) var longitude:Double?
    
    init(
        postToken: String,
        favoriteCheck: Bool,
        favorite_count: Int,
        username: String,
        userIconURL: String,
        text: String,
        imageURL: String,
        latitude: Double,
        longitude: Double
        ){
            self.postToken = postToken
            self.favoriteCheck = favoriteCheck
            self.favoriteCount = favorite_count
            self.username = username
            self.userIconURL = userIconURL
            self.text = text
            self.imageURL = imageURL
            self.latitude = latitude
            self.longitude = longitude
    }
    
    //お気に入り状態の切り替え
    func changeFavoriteState(){
        if self.favoriteCheck == true {
            self.favoriteCount -= 1
        } else {
            self.favoriteCount += 1
        }
        self.favoriteCheck = !self.favoriteCheck
    }
    
    //投稿文のラベルの高さを返す
    func heightForComment(font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: self.text!).boundingRectWithSize(CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        //数値式以上の最小の整数を戻す
        return ceil(rect.height)
    }

}

class TimeLineWrapper {
    
    func getInstance(json:JSON) -> TimeLine {
        
        let timeLine = TimeLine (
            postToken: json["postToken"].stringValue,
            favoriteCheck: json["favorite"].boolValue,
            favorite_count: json["favorite_count"].intValue,
            username: json["user"]["username"].stringValue,
            userIconURL: json["user"]["userIconURL"].stringValue,
            text: json["text"].stringValue,
            imageURL: self.getImageURL(json),
            latitude: json["latitude"].doubleValue,
            longitude: json["longitude"].doubleValue
        )
        
        return timeLine
    }
    
    //画像のURLを指定する
    private func getImageURL(json: JSON) -> String {
        if json["imageURL"] != nil && json["imageURL"].stringValue.utf16.count != 0 {
            return json["imageURL"].stringValue
        } else {
            return ""
        }
    }
}
