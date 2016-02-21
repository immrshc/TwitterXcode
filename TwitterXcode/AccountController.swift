//
//  AccountController.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/20.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit
import AVFoundation

class AccountController: UITableViewController {

    var postArray:[TimeLine] = []
    var refreshCtrl:UIRefreshControl!
    var user_token:String?
    private let app = UIApplication.sharedApplication().delegate as! AppDelegate
    private var selectedIndex:NSInteger! = 0
    
    @IBAction func showPostView(sender: AnyObject) {
        self.showPost()
    }
    
    //投稿画面へ遷移する
    func showPost(){
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PostCtrl")
            as? PostController {
                self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //xibファイルを登録
        let nib = UINib(nibName: "AccountHeader", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "AccountHeader")
        
        //
        self.setUserToken()
        
        //タイムラインを非同期で取得する
        self.getTimeLine()
        //上に引っ張るとリロードされる動作の設定
        self.refreshControl()
        
    }
    
    //タイムラインを非同期で取得する
    func getTimeLine(){
        TimeLineFetcher(user_token: self.user_token!, selected_index: selectedIndex).download { (items) -> Void in
            self.postArray = items
            self.tableView?.reloadData()
        }
    }
    
    private func setUserToken() {
        if self.user_token == nil {
            if let initial_user_token = app.sharedUserData["user_token"] as? String {
                self.user_token = initial_user_token
            } else {
                print("誰のUser_tokenも取得でいませんでした")
            }
        }
    }
    
    //上に引っ張ると投稿をリロードする
    func refresh(){
        TimeLineFetcher(user_token: self.user_token!, selected_index: selectedIndex).download { (items) -> Void in
            self.postArray = items
            self.refreshCtrl.endRefreshing()
            self.tableView?.reloadData()
        }
    }
    
    //上に引っ張るとリロードされる動作の設定
    private func refreshControl(){
        self.refreshCtrl = UIRefreshControl()
        self.refreshCtrl.attributedTitle = NSAttributedString(string: "Loading...")
        self.refreshCtrl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshCtrl)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(130)
    }
    
    //ヘッダーの生成
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("AccountHeader") as! AccountHeaderView
        //self.user_tokenでアカウント情報を非同期でとってからセルに渡さないとリロードできない
        UserFetcher(user_token: user_token!).userDownload { (items) -> Void in
            if items.count != 0 {
                print("③items[0].following_count:\(items[0].following_count)")
                header.myself = items[0]
                header.displayUpdate()
                header.setNeedsDisplay()
            }
        }
        header.selectPostButton.addTarget(self, action: "postUpdate:", forControlEvents: UIControlEvents.ValueChanged)
        header.followingButton.addTarget(self, action: "showFollow:", forControlEvents: UIControlEvents.TouchUpInside)
        header.followerButton.addTarget(self, action: "showFollow:", forControlEvents: UIControlEvents.TouchUpInside)
        return header
    }
    
    func showFollow(sender: UIButton){
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("UserListCtrl")
            as? UserListController {
                vc.dataUpdate(self.user_token)
                if sender.tag == 0 {
                    vc.following_check = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if sender.tag == 1 {
                    vc.following_check = false
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    print("タグが認識されていない")
                }
                
        }
    }
    
    //選択されたタブのインデックスで表示を変更する
    func postUpdate(segcon: UISegmentedControl){
        self.selectedIndex = segcon.selectedSegmentIndex
        TimeLineFetcher(user_token: self.user_token!, selected_index: selectedIndex).download { (items) -> Void in
            self.postArray = items
            self.tableView?.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimeLineCell", forIndexPath: indexPath) as! TimeLineTableViewCell
        cell.displayUpdate(postArray[indexPath.row])
        cell.replyButton.tag = indexPath.row
        cell.replyButton.addTarget(self, action: "showReply:", forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    //replyボタンの設定
    func showReply(sender: UIButton){
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PostCtrl")
            as? PostController {
                vc.receiver_post = postArray[sender.tag]
                self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    //
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let font = UIFont(name: "Times New Roman", size: 14)!
        let text_height = postArray[indexPath.row].heightForComment(font, width: self.getContentWidth())
        let photo_height = self.calculatePhotoHeight(postArray[indexPath.row])
        let other_height = CGFloat(87)
        return text_height + photo_height + other_height
    }
    
    //詳細画面へ遷移する
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("TimeLineDetailCtrl") as? TimeLineDetailController {
            vc.postArray.append(self.postArray[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func calculatePhotoHeight(post: TimeLine) -> CGFloat {
        if let photo_size:CGSize = post.image_info?.size {
            //写真を当てはめる枠となる領域
            let boundingRect =  CGRect(x: 0, y: 0, width: self.getContentWidth(), height: 300)
            //枠となる領域にAspectRatioで写真を当てはめた時の写真の領域を返す
            let rect  = AVMakeRectWithAspectRatioInsideRect(photo_size, boundingRect)
            return rect.size.height
        } else {
            return CGFloat(0)
        }
    }
    
    //写真の幅、およびラベルの幅を返す
    private func getContentWidth() -> CGFloat {
        return CGFloat(self.tableView.bounds.width - 56)
    }
}
