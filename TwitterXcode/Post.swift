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
    private (set) var userToken:String?
    private (set) var userId:String?
    private (set) var text:String?
    private (set) var imageURL:String?
    private (set) var latitude:Double?
    private (set) var longitude:Double?
    
    init(text:String, imageURL:String?, latitude:Double, longitude:Double){
        
        self.userToken = app.sharedUserData["userToken"] as? String
        self.userId = app.sharedUserData["userId"] as? String
        
        self.text = text
        //画像が無ければnilにする
        self.imageURL = imageURL
        
        self.latitude = latitude
        self.longitude = longitude
        
    }

}

class PostWrapper {
    
    static func getInstance(args:[String:AnyObject]) -> Post {
        
        if let text = args["text"] as? String,
            let latitude = args["latitude"] as? Double,
            let longitude = args["longitude"] as? Double {
                let imageURL = self.setImageURL(args)
                let post = Post(text: text, imageURL: imageURL, latitude: latitude, longitude: longitude)
                return post
        } else {
            print("Postの初期化に失敗しました")
            return Post(text: "", imageURL: "", latitude: 0.0, longitude: 0.0)
        }
    }
    
    //画像がない場合の""をnilにする
    private static func setImageURL(args:[String:AnyObject]) -> String? {
        if args["imageURL"]?.stringValue.utf16.count != 0 {
            return args["imageURL"]?.stringValue
        } else {
            return nil
        }
    }
    
}

