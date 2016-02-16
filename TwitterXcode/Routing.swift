//
//  Routing.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/16.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

enum Routing {
    
    enum Base: String {
        //サーバのIPが変わった場合はここだけを変更すれば良い
        case Host = "http://localhost:3000"
    }
    
    enum Auth: String {
        //ユーザ認証
        case SignUp = "/auth/signup.json"
        case SignIn = "/auth/signin.json"
        func getURL() -> String {
            return Routing.Base.Host.rawValue + self.rawValue
        }
    }
    
    enum TimeLine: String {
        //全てのタイムラインの表示
        case TimeLine = "/timeline/show_timeline.json"
        //自分の投稿の表示
        case MyPost = "/timeline/show_mypost.json"
        //お気に入りの投稿の表示
        case MyFavorite = "/timeline/show_myfavorite.json"
        func getURL() -> String  {
            return Routing.Base.Host.rawValue + self.rawValue
        }
    }
    
    enum Post: String {
        //投稿文のリクエスト
        case Text = "/post/create.json"
        //画像のアップロード
        case Image = "/post/upload_process.json"
        func getURL() -> String {
            return Routing.Base.Host.rawValue + self.rawValue
        }
    }
}
