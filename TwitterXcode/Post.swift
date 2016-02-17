//
//  Post.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/16.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit
import CoreLocation

class Post {
    
    private let app = UIApplication.sharedApplication().delegate as! AppDelegate
    private (set) var user_token:String?
    private (set) var user_identifier:String?
    private (set) var text:String?
    private (set) var image_url:String?
    private (set) var latitude:Double?
    private (set) var longitude:Double?
    
    init(text:String, image_url:String?, latitude:Double, longitude:Double){
        
        self.user_token = app.sharedUserData["user_token"] as? String
        self.user_identifier = app.sharedUserData["user_identifier"] as? String
        
        self.text = text
        //画像が無ければnilにする
        self.image_url = image_url
        
        self.latitude = latitude
        self.longitude = longitude
        
    }

}

class PostWrapper {
    
    static func getInstance(args:[String:AnyObject]) -> Post {
        
        if let text = args["text"] as? String,
            let latitude = args["latitude"] as? Double,
            let longitude = args["longitude"] as? Double {
                let image_url = self.setImageURL(args)
                let post = Post(text: text, image_url: image_url, latitude: latitude, longitude: longitude)
                return post
        } else {
            print("Postの初期化に失敗しました")
            return Post(text: "", image_url: "", latitude: 0.0, longitude: 0.0)
        }
    }
    
    //画像がない場合の""をnilにする
    private static func setImageURL(args:[String:AnyObject]) -> String? {
        if args["image_url"]?.stringValue.utf16.count != 0 {
            return args["image_url"]?.stringValue
        } else {
            return nil
        }
    }
    
}

