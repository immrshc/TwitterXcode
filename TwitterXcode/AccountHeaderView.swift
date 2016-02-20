//
//  AccountHeaderTableViewCell.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/15.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit

class AccountHeaderView: UITableViewHeaderFooterView {
    
    var post:TimeLine?
    @IBOutlet weak var iconIV: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var searchUserIdButton: UIButton!
    @IBOutlet weak var follewingButton: UIButton!
    @IBOutlet weak var followerButton: UIButton!
    @IBOutlet weak var selectPostButton: UISegmentedControl!
    
    func displayUpdate(timeline: TimeLine){
        post = timeline
        userNameLabel.text = post?.username
        
        //ユーザのアイコン画像を設定する
        //userIV.sd_setImageWithURL(NSURL(string: (post?.icon_image_url)!))
        iconIV.sd_setImageWithURL(NSURL(string: "TwitterIcon.png"))
        
    }
    
}
