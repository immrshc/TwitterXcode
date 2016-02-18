//
//  TimeLineTableViewCell.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/15.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit
import AVFoundation

class TimeLineTableViewCell: UITableViewCell {

    var post:TimeLine?
    @IBOutlet weak var userIV: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var searchUserIdButton: UIButton!
    @IBOutlet weak var postTV: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCountLabe: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var postTextHeight: NSLayoutConstraint!
    @IBOutlet weak var postIV: UIImageView!
    @IBOutlet weak var postImageHeight: NSLayoutConstraint!
    
    //初期設定をする
    func displayUpdate(timeline: TimeLine){
        
        post = timeline
        userNameLabel.text = post?.username
        
        //フォントとセルの幅からラベルの高さを返す
        postTV.text = post!.text
        let font = UIFont(name: "Times New Roman", size: 14)!
        postTextHeight.constant = timeline.heightForComment(font, width: postTV.bounds.width)
        
        //アスペクト比に応じた写真の高さを取得して、セルの写真の高さにする
        if let imageURL = post?.image_info?.url {
            postIV.sd_setImageWithURL(NSURL(string: imageURL))
            let boundingRect =  CGRect(x: 0, y: 0, width: postIV.bounds.width, height: CGFloat(300))
            let rect  = AVMakeRectWithAspectRatioInsideRect(postIV.bounds.size, boundingRect)
            postImageHeight.constant = rect.size.height
        } else {
            postImageHeight.constant = CGFloat(0)
        }
        
        //ユーザのアイコン画像を設定する
        //userIV.sd_setImageWithURL(NSURL(string: (post?.icon_image_url)!))
        userIV.sd_setImageWithURL(NSURL(string: "TwitterIcon.png"))
        
        //お気に入りボタンの更新処理を設定する
        favoriteButton.addTarget(self, action: "favoriteUpdate:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //お気に入りボタンの初期状態の設定
        favoriteCountLabel.text = String(post!.favorite_count)
        if post!.favorite_check {
            favoriteButton.setTitleColor(UIColor.yellowColor(), forState: .Normal)
        } else {
            favoriteButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        }
    }
    
    //お気に入りボタンの処理
    func favoriteUpdate(sender: UIButton){
        if let post:TimeLine = post {
            //お気に入りボタンが押されると色を変える
            if post.favorite_check == false {
                favoriteButton.setTitleColor(UIColor.yellowColor(), forState: .Normal)
            } else {
                favoriteButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
            }
            //お気に入り状態とお気に入り数を変更する
            post.changeFavoriteState()
            favoriteCountLabel.text = String(post.favorite_count)
        }
    }
}
