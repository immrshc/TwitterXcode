//
//  PostDispatcher.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/16.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import Alamofire
import SwiftyJSON

class PostDispatcher {
    
    private var postURL = Routing.Post.Text.getURL()
    private var uploadURL = Routing.Post.Image.getURL()
    private var params:[String:[String:AnyObject]] = [:]
    private var fileURL:NSURL?

    init(post:Post, receiver_post: TimeLine?){
        self.setParams(post, receiver_post: receiver_post)
    }
    
    private func setParams(post: Post, receiver_post: TimeLine?){
        if let user_token:String = post.user_token,
            let user_identifier:String = post.user_identifier,
            let text:String = post.text,
            let latitude:Double = post.latitude,
            let longitude:Double = post.longitude {
                
                params = [
                    "user":[
                        "user_token": user_token,
                        "user_identifier": user_identifier
                    ],
                    "post":[
                        "text": text,
                        "latitude": latitude,
                        "longitude": longitude
                    ]
                ]
                
                if let image_url = post.image_url {
                    params["post"]?.updateValue(image_url, forKey: "image_url")
                }
                
                if let receiver_token = receiver_post?.post_token {
                    params["post"]?.updateValue(receiver_token, forKey: "receiver_token")
                }
        }
    }
    
    //画像がない投稿情報をリクエスト
    func upload(callback: (Bool) -> Void){
                Alamofire.request(.POST, postURL, parameters: params).responseJSON{ response in
                    if response.result.isSuccess,
                        let res = response.result.value as? [String:AnyObject]{
                            if res["result"]?.intValue == 1 {
                                callback(true)
                            } else {
                                callback(false)
                            }
                    } else {
                        callback(false)
                    }
                }
    }
    
    //画像のアップロードと投稿情報のリクエストをする
    func uploadWithImage(callback: (Bool) -> Void){
        
        if let imageURL = params["post"]!["image_url"] as? NSURL {
            self.fileURL = imageURL
        }
        
        Alamofire.upload(.POST, uploadURL, multipartFormData: { (multipartFormData) in
                if let user_token = self.params["user"]!["user_token"] as? String,
                    let user_identifier = self.params["user"]!["user_identifier"] as? String,
                    let text = self.params["post"]!["text"] as? String,
                    let latitude = self.params["post"]!["latitude"] as? Double,
                    let longitude = self.params["post"]!["longitude"] as? Double {
                        multipartFormData.appendBodyPart(data: user_token.dataUsingEncoding(NSUTF8StringEncoding)!, name: "user_token")
                        multipartFormData.appendBodyPart(data: user_identifier.dataUsingEncoding(NSUTF8StringEncoding)!, name: "user_identifier")
                        multipartFormData.appendBodyPart(data: text.dataUsingEncoding(NSUTF8StringEncoding)!, name: "text")
                        multipartFormData.appendBodyPart(data: String(latitude).dataUsingEncoding(NSUTF8StringEncoding)!, name: "latitude")
                        multipartFormData.appendBodyPart(data: String(longitude).dataUsingEncoding(NSUTF8StringEncoding)!, name: "longitude")
                }
                if let receiver_token = self.params["post"]!["receiver_token"] as? String {
                    multipartFormData.appendBodyPart(data: receiver_token.dataUsingEncoding(NSUTF8StringEncoding)!, name: "receiver_token")
                }
            
                //画像をアップロードする
                if let fileURL = self.fileURL {
                    multipartFormData.appendBodyPart(fileURL: fileURL, name: "image")
                }

            },
            //リクエストボディ生成のエンコード処理が完了したら呼ばれる
            encodingCompletion: { (encodingResult) in
                switch encodingResult {
                //エンコード成功時
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        if response.result.isSuccess,
                            let res = response.result.value as? [String:AnyObject]{
                                if res["result"]?.intValue == 1 {
                                    callback(true)
                                } else {
                                    callback(false)
                                }
                        } else {
                            callback(false)
                        }
                    }
                //エンコード失敗時
                case .Failure(let encodingError):
                    print(encodingError)
                    callback(false)
                }
        })
    }

}
