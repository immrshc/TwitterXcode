//
//  RelationshipHander.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/21.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit
import Alamofire

class RelationshipHander {
    
    var baseURL:String?
    private var defaultParameter:[String:[String:AnyObject]] = [:]
    private let app = UIApplication.sharedApplication().delegate as! AppDelegate
    
    init(following_token: String){
        defaultParameter = [
            "user":[
                "follower_token":(app.sharedUserData["user_token"])!,
                "following_token":following_token
            ]
        ]
    }
    
    func addFollowing(callback: (Bool)->Void){
        baseURL = Routing.Relationship.AddFollowing.getURL()
        self.update(callback)
    }
    
    func subtractFollowing(callback: (Bool)->Void){
        baseURL = Routing.Relationship.SubtractFollowing.getURL()
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
