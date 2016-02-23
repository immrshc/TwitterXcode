//
//  ResponseHandler.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/19.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import Alamofire

class ResponseHandler {

    var baseURL:String?
    private var defaultParameter:[String:[String:AnyObject]] = [:]
    private let app = UIApplication.sharedApplication().delegate as! AppDelegate
    
    init(post: TimeLine){
        defaultParameter = [
            "user":[
                "user_token":(app.sharedUserData["user_token"])!,
                "user_identifier":(app.sharedUserData["user_identifier"])!
            ],
            "post":[
                "post_token": post.post_token!
            ]
        ]
    }
    
    func addFavorite(callback: (Bool)->Void){
        baseURL = Routing.Response.AddFavorite.getURL()
        self.update(callback)
    }
    
    func subtractFavorite(callback: (Bool)->Void){
        baseURL = Routing.Response.SubtractFavorite.getURL()
        self.update(callback)
    }
    
    func addRetweet(callback: (Bool)->Void){
        baseURL = Routing.Response.AddRetweet.getURL()
        self.update(callback)
    }
    
    func subtractRetweet(callback: (Bool)->Void){
        baseURL = Routing.Response.SubtractRetweet.getURL()
        self.update(callback)
    }
    
    //
    private func update(callback:(Bool)->Void){
        Alamofire.request(.POST, baseURL!, parameters: defaultParameter).responseJSON { response in
            if response.result.isSuccess,
                let res = response.result.value as? [String:AnyObject]{
                    //trueなら1, falseなら0になっている
                    if res["result"]?.integerValue == 1 {
                        callback(true)
                    } else {
                        callback(false)
                    }
            } else {
                callback(false)
            }
        }
    }
    
}
