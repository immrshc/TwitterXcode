//
//  TimeLineFetcher.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/16.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import Alamofire
import SwiftyJSON

class TimeLineFetcher {

    var baseURL:String?
    private var defaultParameter:[String:[String:AnyObject]] = [:]
    private let app = UIApplication.sharedApplication().delegate as! AppDelegate
    init(){
        defaultParameter = [
            "user":[
                "userToken":(app.sharedUserData["userToken"])!,
                "userId":(app.sharedUserData["userId"])!
            ]
        ]
        baseURL = Routing.TimeLine.TimeLine.getURL()
    }
    
    //postTokenに紐付いた投稿と、それに対する返信の投稿の配列を取る
    init(postToken: String){
        defaultParameter = [
            "post":[
                "postToken": postToken,
            ]
        ]
        baseURL = Routing.TimeLine.Reply.getURL()
    }
    
    func download(callback:([TimeLine])->Void){
        Alamofire.request(.POST, baseURL!, parameters: defaultParameter).responseJSON{_, _, result in
            if result.isSuccess,
                let posts = result.value as? [AnyObject]{
                    var postArray:[TimeLine] = []
                    for var i = 0; i < posts.count; i++ {
                        let post = TimeLineWrapper().getInstance(JSON(posts[i]))
                        postArray.append(post)
                    }
                    callback(postArray)
            } else {
                callback([])
                print("Tokenが間違っています")
            }
        }
    }

}
