//
//  ViewController.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/15.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit

class TopController: UIViewController {
    
    
    @IBOutlet weak var backGroundIV: UIImageView!
    
    @IBAction func signUp(sender: AnyObject) {
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SignUpCtrl") as? SignUpController {
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func signIn(sender: AnyObject) {
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SignInCtrl") as? SignInController {
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        backGroundIV.image = UIImage(named: "BackGroundImage.jpg")
    }
    
}

