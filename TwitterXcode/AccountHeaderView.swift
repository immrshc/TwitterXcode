//
//  AccountHeaderTableViewCell.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/15.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit

class AccountHeaderView: UITableViewHeaderFooterView {
    
    var myself: User?
    @IBOutlet weak var iconIV: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var searchUserIdButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followerButton: UIButton!
    @IBOutlet weak var selectPostButton: UISegmentedControl!
    
    func displayUpdate(user_token: String?){
        
        followingButton.tag = 0
        followerButton.tag = 1
        
        UserFetcher(user_token: user_token!).userDownload { (items) -> Void in
            print("AccountHeaderView.user_token: \(user_token)")
            if items.count != 0 {
                self.myself = items[0]
                self.userNameLabel.text = self.myself!.username
                //ユーザのアイコン画像を設定する
                //userIV.sd_setImageWithURL(NSURL(string: (myself.icon_image_url)!))
                self.iconIV.sd_setImageWithURL(NSURL(string: "TwitterIcon.png"))
                //リロードが必要か確認する
            }
        }
        
    }
}
