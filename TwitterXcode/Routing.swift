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
        case SignUp = "/authentication/sign_up.json"
        
        case SignIn = "/authentication/sign_in.json"
        
        func getURL() -> String {
            return Routing.Base.Host.rawValue + self.rawValue
        }
    }
    
    enum Account: String {
        //[User]
        case MySelf = "/account/show/myself.json"
        case Following = "/account/show/following.json"
        case Follower = "/account/show/follower.json"
        func getURL() -> String {
            return Routing.Base.Host.rawValue + self.rawValue
        }
    }
    
    enum Relationship: String {
        case AddFollowing = "/account/following/add.json"
        case SubtractFollowing = "/account/following/subtract.json"
        func getURL() -> String  {
            return Routing.Base.Host.rawValue + self.rawValue
        }
    }
    
    enum Post: String {
        //投稿文のリクエスト
        case Text = "/post/without.json"
        //画像のアップロード
        case Image = "/post/with.json"
        
        func getURL() -> String {
            return Routing.Base.Host.rawValue + self.rawValue
        }
    }
    
    enum TimeLine: String {
        //全てのタイムラインの表示
        case TimeLine = "/timeline/show.json"
        //投稿に紐付いた返信の投稿を表示
        case Reply = "/timeline/show/reply.json"
        //自分の投稿の表示
        case MyPost = "/timeline/show/mypost.json"
        //お気に入りの投稿の表示
        case MyFavorite = "/timeline/show/myfavorite.json"
        //
        case Geography = "/timeline/show/geography.json"
        
        func getURL() -> String  {
            return Routing.Base.Host.rawValue + self.rawValue
        }
    }
    
    enum Response: String {
        //お気に入り情報の追加
        case AddFavorite = "/timeline/favorite/add.json"
        //お気に入り情報の削除
        case SubtractFavorite = "/timeline/favorite/subtract.json"
        //リツイート情報の追加
        case AddRetweet = "/timeline/retweet/add.json"
        //リツイート情報の削除
        case SubtractRetweet = "/timeline/retweet/subtract.json"
        
        func getURL() -> String  {
            return Routing.Base.Host.rawValue + self.rawValue
        }
    }
    
}
