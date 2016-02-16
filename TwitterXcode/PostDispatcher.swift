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

    init(post:Post){
        self.setParams(post)
    }
    
    private func setParams(post: Post){
        if let userToken:String = post.userToken,
            let userId:String = post.userId,
            let text:String = post.text,
            let latitude:Double = post.latitude,
            let longitude:Double = post.longitude {
                
                params = [
                    "user":[
                        "userToken": userToken,
                        "userId": userId
                    ],
                    "post":[
                        "text": text,
                        "latitude": latitude,
                        "longitude": longitude
                    ]
                ]
                
                if let imageURL = post.imageURL {
                    params.updateValue(["imageURL": imageURL], forKey: "post")
                }
        }
    }
    
    //画像がない投稿情報をリクエスト
    func upload(callback: (Bool) -> Void){
                Alamofire.request(.POST, postURL, parameters: params).responseJSON{_, _, result in
                    if result.isSuccess,
                        let res = result.value as? [String:AnyObject]{
                            if res["result"]!.intValue == 1 {
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
        
        if let imageURL = params["post"]!["imageURL"] as? String {
            let postImage: NSString = NSString(string: imageURL)
            fileURL = NSBundle.mainBundle().URLForResource(postImage.stringByDeletingPathExtension, withExtension: postImage.pathExtension)!
        }
        
        Alamofire.upload(.POST, uploadURL, multipartFormData: { (multipartFormData) in
                //画像をアップロードする
                if let fileURL = self.fileURL {
                    multipartFormData.appendBodyPart(fileURL: fileURL, name: "image")
                }
                //辞書型データをNSData型にする
                let userData:NSData = NSKeyedArchiver.archivedDataWithRootObject(self.params["user"]!)
                multipartFormData.appendBodyPart(data: userData, name: "user")
                let postData:NSData = NSKeyedArchiver.archivedDataWithRootObject(self.params["post"]!)
                multipartFormData.appendBodyPart(data: postData, name: "post")

            },
            //リクエストボディ生成のエンコード処理が完了したら呼ばれる
            encodingCompletion: { (encodingResult) in
                switch encodingResult {
                //エンコード成功時
                case .Success(let upload, _, _):
                    upload.responseJSON { _, _, result in
                        print("result:\(result.isSuccess)")
                        callback(result.isSuccess)
                    }
                //エンコード失敗時
                case .Failure(let encodingError):
                    print(encodingError)
                    callback(false)
                }
        })
    }

}
