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
    
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followerButton: UIButton!
    @IBOutlet weak var selectPostButton: UISegmentedControl!
    
    
    func displayUpdate(){
        
        followingButton.tag = 0
        followerButton.tag = 1
        
        userNameLabel.text = self.myself!.username
        followingButton.setTitle("フォロー: \(self.myself!.following_count)", forState: .Normal)
        followerButton.setTitle("フォロワー: \(self.myself!.follower_count)", forState: .Normal)
        followButton.addTarget(self, action: "followUpdate:", forControlEvents: UIControlEvents.TouchUpInside)
        //ユーザのアイコン画像を設定する
        iconIV.sd_setImageWithURL(NSURL(string: (myself!.icon_image_url)))
        
    }
    
    func followUpdate(sender: UIButton){
        //user.user_token :相手のトークン
        //user_token = app :自分のトークン
        if myself?.follow_state  == true {
            RelationshipHander(following_token: myself!.user_token).subtractFollowing { (result) -> Void in
                if result == true {
                    //following_stateを変える
                    self.myself?.follow_state = false
                    //ボタンの色を変える
                    self.followableUser()
                }
            }
        } else {
            RelationshipHander(following_token: myself!.user_token).addFollowing { (result) -> Void in
                if result == true {
                    //following_stateを変える
                    self.myself?.follow_state = true
                    //ボタンの色を変える
                    self.followingUser()
                }
            }
            
        }
    }
    
    private func followingUser(){
        followButton.backgroundColor = UIColor.cyanColor()
        followButton.setTitle("フォロー中", forState: .Normal)
        followButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
    private func followableUser(){
        followButton.backgroundColor = UIColor.whiteColor()
        followButton.setTitle("フォローする", forState: .Normal)
        followButton.setTitleColor(UIColor.cyanColor(), forState: .Normal)
    }
}
