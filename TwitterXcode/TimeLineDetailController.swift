//
//  TimeLineDetailViewController.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/15.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit
import AVFoundation

class TimeLineDetailController: UITableViewController {
    
    var postArray:[TimeLine] = []
    var replyArray:[TimeLine] = []
    var refreshCtrl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("postArray[0]: \(postArray[0])")
        //タイムラインを非同期で取得する
        self.getTimeLine()
        
        //上に引っ張るとリロードされる動作の設定
        self.refreshControl()

    }
    
    //タイムラインを非同期で取得する
    func getTimeLine(){
        if let post_token = postArray[0].post_token {
            TimeLineFetcher(post_token: post_token).download { (items) -> Void in
                self.replyArray = items
                self.tableView.reloadData()
            }
        }
    }
    
    //上に引っ張ると投稿をリロードする
    func refresh(){
        if let post_token = postArray[0].post_token {
            TimeLineFetcher(post_token: post_token).download { (items) -> Void in
                self.replyArray = items
                self.tableView.reloadData()
                self.refreshCtrl.endRefreshing()
            }
        }
    }
    
    //上に引っ張るとリロードされる動作の設定
    private func refreshControl(){
        self.refreshCtrl = UIRefreshControl()
        self.refreshCtrl.attributedTitle = NSAttributedString(string: "Loading...")
        self.refreshCtrl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshCtrl)
    }
    
    //セクション数を指定する
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else {
            if replyArray.count != 0 {
                return "Reply"
            } else {
                return nil
            }
        }
    }
    
    //セルの数を指定する
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return postArray.count
        } else if section == 1 {
            return replyArray.count
        } else {
            return 0
        }
    }
    
    //セルを生成する
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("TimeLineDetailCell", forIndexPath: indexPath) as! TimeLineDetailTableViewCell
            cell.displayUpdate(postArray[indexPath.row])
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("TimeLineDetailCell", forIndexPath: indexPath) as! TimeLineDetailTableViewCell
            cell.displayUpdate(replyArray[indexPath.row])
            return cell
            
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let font = UIFont(name: "Times New Roman", size: 14)!
        if indexPath.section == 0 {
            let text_height = postArray[indexPath.row].heightForComment(font, width: self.getContentWidth())
            let photo_height = self.calculatePhotoHeight(postArray[indexPath.row])
            let other_height = CGFloat(130)
            return other_height + text_height + photo_height
        } else {
            let text_height = replyArray[indexPath.row].heightForComment(font, width: self.getContentWidth())
            let photo_height = self.calculatePhotoHeight(replyArray[indexPath.row])
            let other_height = CGFloat(130)
            return other_height + text_height + photo_height
        }
    }
    
    private func calculatePhotoHeight(post: TimeLine) -> CGFloat {
        if let photo_size:CGSize = post.image_info?.size {
            let boundingRect =  CGRect(x: 0, y: 0, width: self.getContentWidth(), height: CGFloat(MAXFLOAT))
            let rect  = AVMakeRectWithAspectRatioInsideRect(photo_size, boundingRect)
            return rect.size.height
        } else {
            return CGFloat(0)
        }
    }
    
    //写真の幅、およびラベルの幅を返す
    private func getContentWidth() -> CGFloat {
        return CGFloat(self.tableView.bounds.width - 16)
    }

}
