//
//  UserAuthentication.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/16.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserFetcher {
    
    private var baseURL:String!
    private var defaultParameter: [String:[String:String]] = [:]

    //SignIn
    init(user_identifier: String, password: String){
        self.defaultParameter = [
            "user":[
                "user_identifier": user_identifier,
                "password": password
            ]
        ]
        self.baseURL = Routing.Auth.SignIn.getURL()
    }
    
    //SignUp
    init(user_identifier: String, password: String, username: String, email: String){
        self.defaultParameter = [
            "user":[
                "user_identifier": user_identifier,
                "password": password,
                "username": username,
                "email": email
            ]
        ]
        self.baseURL = Routing.Auth.SignUp.getURL()
    }
    
    init(user_token: String){
        self.defaultParameter = [
            "user": [
                "user_token": user_token
            ]
        ]
        self.baseURL = Routing.Account.MySelf.getURL()
    }
    
    //
    init(user_token: String, following_check: Bool){
        self.defaultParameter = [
            "user": [
                "user_token": user_token
            ]
        ]
        self.setURL(following_check)
    }
    
    private func setURL(following_check: Bool) -> Void {
        if following_check == true {
            //
            self.baseURL = Routing.Account.Following.getURL()
        } else {
            //
            self.baseURL = Routing.Account.Follower.getURL()
        }
    }
    
    func download(callback:(Bool)->Void){
        Alamofire.request(.POST, baseURL, parameters: defaultParameter).responseJSON {_, _, result in
            if result.isSuccess,
                let res = result.value as? [String:AnyObject]{
                    //trueなら1, falseなら0になっている
                    if res["result"]?.integerValue == 1 {
                        //userDataをストレージに保存する
                        let userData = User(json: JSON(res))
                        self.saveUserData(userData)
                        callback(true)
                    }
            }
        }
    }
    
    func userDownload(callback:([User])->Void){
        Alamofire.request(.POST, baseURL!, parameters: defaultParameter).responseJSON{_, _, result in
            if result.isSuccess,
                let users = result.value as? [AnyObject]{
                    print("users: \(users)")
                    var userArray:[User] = []
                    for var i = 0; i < users.count; i++ {
                        let user = User(json: JSON(users[i]))
                        userArray.append(user)
                    }
                    //print("userArray: \(userArray)")
                    callback(userArray)
            } else {
                callback([])
                print("Tokenが間違っています")
            }
        }
    }
    
    //userDataをストレージに保存するメソッド
    private func saveUserData(userData: User){
        //暫定的にメモリに保存しておく
        //後でストレージへの保存にする
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        app.sharedUserData = userData.getUserData()
    }
}
