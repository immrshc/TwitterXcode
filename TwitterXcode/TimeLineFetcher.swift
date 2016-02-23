//
//  TimeLineFetcher.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/16.
//  Copyright © 2016年 今村翔一. All rights reserved.
//


import Alamofire
import AlamofireImage
import SwiftyJSON
import CoreLocation

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
    
    //user_tokenに紐付いた投稿の配列を取る
    init(user_token: String, selected_index: NSInteger){
        defaultParameter = [
            "user":[
                "user_token":user_token
            ]
        ]
        self.setURL(selected_index)
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

    func locationUpdate(location:CLLocationCoordinate2D){
        defaultParameter.updateValue(["latitude": location.latitude, "longitude": location.longitude], forKey: "map")
        baseURL = Routing.TimeLine.Geography.getURL()
    }

    
    func download(callback:([TimeLine])->Void){
        Alamofire.request(.POST, baseURL!, parameters: defaultParameter).responseJSON{ response in
            if response.result.isSuccess,
                let posts = response.result.value as? [AnyObject]{
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
    
    /*
    func imageDownload(url: String) -> Void {
        Alamofire.request(.GET, "aaaaa").responsImage{ response in
            if response.result.isSuccess,
                let data = response.result.value as? [AnyObject]{
                    dispatch_async(dispatch_get_main_queue()) { () in
                        self.photoImage.image = UIImage(data: data as NSData)
                    }
                    callback(postArray)
            } else {
                callback([])
                print("Tokenが間違っています")
            }
        }
    }
    */

}
