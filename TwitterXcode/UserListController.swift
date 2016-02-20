//
//  UserListController.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/20.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit

class UserListController: UITableViewController {
    
    
    var user_token:String?
    var following_check: Bool = true
    var userArray: [User] = []
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
        if let user_token = user_token {
            UserFetcher(user_token: user_token, following_check: following_check).userDownload { (items) -> Void in
                self.userArray = items
                self.tableView.reloadData()
                //print("userArray: \(self.userArray)")
            }
        }
    }
    
    func dataUpdate(user_token: String?){
        self.user_token = user_token
    }
    
    //上に引っ張ると投稿をリロードする
    func refresh(){
        if let user_token = user_token {
            UserFetcher(user_token: user_token, following_check: following_check).userDownload { (items) -> Void in
                self.userArray = items
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


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserListCell", forIndexPath: indexPath) as! UserListTableViewCell
        cell.displayUpdate(userArray[indexPath.row])
        return cell
    }
    
    //アカウント画面へ遷移する
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AccountCtrl") as? AccountController {
            print("userArray[indexPath.row]:\(userArray[indexPath.row])")
            print("userArray[indexPath.row].user_token:\(userArray[indexPath.row].user_token)")
            vc.user_token = userArray[indexPath.row].user_token
            //ここが原因
            print("vc.user_token: \(vc.user_token)")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
