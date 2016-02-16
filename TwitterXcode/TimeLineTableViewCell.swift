//
//  TimeLineTableViewCell.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/15.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class TimeLineTableViewCell: UITableViewCell, TTTAttributedLabelDelegate {

    var post:TimeLine?
    @IBOutlet weak var userIV: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var searchUserIdButton: UIButton!
    @IBOutlet weak var postTV: UITextView!
    @IBOutlet weak var imageUrlLabel: TTTAttributedLabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCountLabe: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var postHeight: NSLayoutConstraint!
    
    //IBOutletやIBActionがロードされた後に呼び出される
    override func awakeFromNib() {
        super.awakeFromNib()
        
        postTV.text = post!.text
        userNameLabel.text = post?.username
        //ユーザのアイコン画像を設定する
        userIV.sd_setImageWithURL(NSURL(string: (post?.userIconURL)!))
        
        //お気に入りボタンの更新処理を設定する
        favoriteButton.addTarget(self, action: "favoriteUpdate:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(favoriteButton)
        
        //お気に入りボタンの初期状態の設定
        favoriteCountLabel.text = String(post!.favoriteCount)
        if post!.favoriteCheck {
            favoriteButton.setTitleColor(UIColor.yellowColor(), forState: .Normal)
        } else {
            favoriteButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        }

        //文字列のURLをリンクさせる
        imageUrlLabel.delegate = self
        imageUrlLabel.enabledTextCheckingTypes = NSTextCheckingType.Link.rawValue
        imageUrlLabel.text = post?.imageURL
    }

    //初期設定をする
    func displayUpdate(timeline: TimeLine){
        post = timeline
        //フォントとセルの幅からラベルの高さを返す
        let font = UIFont(name: "System", size: 14)!
        postHeight.constant = timeline.heightForComment(font, width: postTV.bounds.width)
    }
    
    //お気に入りボタンの処理
    func favoriteUpdate(sender: UIButton){
        if let post:TimeLine = post {
            //お気に入りボタンが押されると色を変える
            if post.favoriteCheck == false {
                favoriteButton.setTitleColor(UIColor.yellowColor(), forState: .Normal)
            } else {
                favoriteButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
            }
            //お気に入り状態とお気に入り数を変更する
            post.changeFavoriteState()
            favoriteCountLabel.text = String(post.favoriteCount)
        }
    }
    
    //URLを開く
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        UIApplication.sharedApplication().openURL(url)
    }

}
