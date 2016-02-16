//
//  TimeLineDetailViewController.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/15.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit

class TimeLineDetailController: UITableViewController {
    
    var postArray:[TimeLine] = []
    var refreshCtrl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //タイムラインを非同期で取得する
        self.getTimeLine()
        
        //上に引っ張るとリロードされる動作の設定
        self.refreshControl()

    }
    
    //タイムラインを非同期で取得する
    func getTimeLine(){
        let postToken = postArray[0].postToken
        TimeLineFetcher(postToken: postToken!).download { (items) -> Void in
            self.postArray = items
            self.tableView.reloadData()
        }
    }
    
    //上に引っ張ると投稿をリロードする
    func refresh(){
        let postToken = postArray[0].postToken
        TimeLineFetcher(postToken: postToken!).download { (items) -> Void in
            self.postArray = items
            self.refreshCtrl.endRefreshing()
            self.tableView.reloadData()
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
        return 0
    }
    
    //セルの数を指定する
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    //セルを生成する
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimeLineDetailCell", forIndexPath: indexPath) as! TimeLineDetailTableViewCell
        cell.displayUpdate(postArray[indexPath.row])
        return cell
    }

}
