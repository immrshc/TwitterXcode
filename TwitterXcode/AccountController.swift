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
        
        //タイムラインを非同期で取得する
        self.getTimeLine()
        //上に引っ張るとリロードされる動作の設定
        self.refreshControl()
        
    }
    
    //タイムラインを非同期で取得する
    func getTimeLine(){
        TimeLineFetcher(selected_index: selectedIndex).download { (items) -> Void in
            self.postArray = items
            self.tableView?.reloadData()
        }
    }
    
    //上に引っ張ると投稿をリロードする
    func refresh(){
        TimeLineFetcher(selected_index: selectedIndex).download { (items) -> Void in
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
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("AccountHeader")
        let header = cell as! AccountHeaderView
        //header.displayUpdate()
        header.selectPostButton.addTarget(self, action: "postUpdate:", forControlEvents: UIControlEvents.ValueChanged)
        return header
    }
    
    //選択されたタブのインデックスで表示を変更する
    func postUpdate(segcon: UISegmentedControl){
        self.selectedIndex = segcon.selectedSegmentIndex
        TimeLineFetcher(selected_index: selectedIndex).download { (items) -> Void in
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
