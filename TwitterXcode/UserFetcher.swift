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
    
    func download(callback:(Bool)->Void){
        Alamofire.request(.POST, baseURL, parameters: defaultParameter).responseJSON {_, _, result in
            if result.isSuccess,
                let res = result.value as? [String:AnyObject]{
                    //trueなら1, falseなら0になっている
                    print(res)
                    if res["result"]!.integerValue == 1 {
                        //userDataをストレージに保存する
                        let userData = User(json: JSON(res))
                        self.saveUserData(userData)
                        callback(true)
                    }
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
