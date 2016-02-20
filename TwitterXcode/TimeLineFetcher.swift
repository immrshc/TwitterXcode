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
                "user_token":(app.sharedUserData["user_token"])!,
                "user_identifier":(app.sharedUserData["user_identifier"])!
            ]
        ]
        baseURL = Routing.TimeLine.TimeLine.getURL()
    }
    
    //postTokenに紐付いた投稿に対する返信の投稿の配列を取る
    init(post_token: String){
        defaultParameter = ["post":["post_token": post_token]]
        baseURL = Routing.TimeLine.Reply.getURL()
    }
    
    convenience init(selected_index: NSInteger){
        self.init()
        self.setURL(selected_index)
        print("self.baseURL: \(self.baseURL)")
    }
    
    private func setURL(segmentIndex:NSInteger) -> Void {
        switch segmentIndex {
        case 0:
            //自分の投稿を表示する
            self.baseURL = Routing.TimeLine.MyPost.getURL()
        case 1:
            //自分のお気に入りした投稿を表示する
            self.baseURL = Routing.TimeLine.MyFavorite.getURL()
        default:
            print("error")
        }
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
