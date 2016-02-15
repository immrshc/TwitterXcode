//
//  PostControllerViewController.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/16.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit

class PostController: UIViewController {

    @IBAction func backView(sender: AnyObject) {
    }
    @IBAction func postUpload(sender: AnyObject) {
    }
    @IBOutlet weak var postTV: UITextView!
    @IBOutlet weak var postIV: UIImageView!
    @IBOutlet weak var defaultIVButton: UITabBarItem!
    @IBOutlet weak var selectIVButton: UITabBarItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
