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
    
    func displayUpdate(){
        
        followingButton.tag = 0
        followerButton.tag = 1
        
        self.userNameLabel.text = self.myself!.username
        self.followingButton.setTitle("フォロー: \(self.myself!.following_count)", forState: .Normal)
        self.followerButton.setTitle("フォロワー: \(self.myself!.follower_count)", forState: .Normal)
        //ユーザのアイコン画像を設定する
        //userIV.sd_setImageWithURL(NSURL(string: (myself.icon_image_url)!))
        self.iconIV.sd_setImageWithURL(NSURL(string: "TwitterIcon.png"))
        
    }
}
