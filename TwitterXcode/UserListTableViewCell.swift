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
    @IBAction func followButton(sender: AnyObject) {
        
    }
    func displayUpdate(user: User){
        self.user = user
        iconIV.sd_setImageWithURL(NSURL(string: self.user!.icon_image_url))
        userNameLabel.text = self.user?.username
        userIdLabel.text = self.user?.user_identifier
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
