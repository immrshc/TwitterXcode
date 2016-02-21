//
//  UserListTableViewCell.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/20.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit

class UserListTableViewCell: UITableViewCell {
    
    var user:User?
    @IBOutlet weak var iconIV: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    func displayUpdate(user: User){
        self.user = user
        iconIV.sd_setImageWithURL(NSURL(string: self.user!.icon_image_url))
        userNameLabel.text = self.user?.username
        userIdLabel.text = self.user?.user_identifier
        if user.follow_state == true {
            self.followingUser()
        } else {
            self.followableUser()
        }
        followButton.addTarget(self, action: "followUpdate:", forControlEvents: UIControlEvents.TouchUpInside)
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
    
    func followUpdate(sender: UIButton){
        //user.user_token :相手のトークン
        //user_token = app :自分のトークン
        if user?.follow_state  == true {
            RelationshipHander(following_token: user!.user_token).subtractFollowing { (result) -> Void in
                if result == true {
                    //following_stateを変える
                    self.user?.follow_state = false
                    //ボタンの色を変える
                    self.followableUser()
                }
            }
        } else {
            RelationshipHander(following_token: user!.user_token).addFollowing { (result) -> Void in
                if result == true {
                    //following_stateを変える
                    self.user?.follow_state = true
                    //ボタンの色を変える
                    self.followingUser()
                }
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
