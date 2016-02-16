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
    private var defaultParameter: [String:String] = [:]

    //SignIn
    init(userId: String, password: String){
        self.defaultParameter = [
            "userId": userId,
            "password": password
        ]
        self.baseURL = Routing.Auth.SignIn.getURL()
    }
    
    //SignUp
    convenience init(userId: String, password: String, username: String, email: String){
        self.init(userId: userId, password: password)
        self.defaultParameter.updateValue(username, forKey: "username")
        self.defaultParameter.updateValue(email, forKey: "email")
        self.baseURL = Routing.Auth.SignUp.getURL()
    }
    
    func download(callback:(Bool)->Void){
        Alamofire.request(.GET, baseURL, parameters: defaultParameter).responseJSON {_, _, result in
            if result.isSuccess,
                let res = result.value as? [String:AnyObject]{
                    //trueなら1, falseなら0になっている
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
