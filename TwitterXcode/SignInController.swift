//
//  LoginControllerViewController.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/15.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit

class SignInController: UIViewController, UITextInputTraits, UITextFieldDelegate {

    @IBAction func backView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBOutlet weak var userIdTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //入力したパスワードを見えないようにする
        passwordTF.secureTextEntry = true
        self.setReturnKeyType()
        self.setTextField(userIdTF, s: "ユーザIDを入力して下さい")
        self.setTextField(passwordTF, s: "パスワードを入力して下さい")
    }
    
    //Returnキーの動作設定
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //キーボードを消す
        textField.resignFirstResponder()
        //最後の入力が終わると値を検証し、画面遷移する
        if textField.returnKeyType == .Send {
            self.checkTextField()
        }
        return true
    }

    //Returnキーの表示設定
    private func setReturnKeyType(){
        userIdTF.returnKeyType = .Next
        passwordTF.returnKeyType = .Send
    }
    
    //テキストフィールドの基本設定
    private func setTextField(tf: UITextField, s: String) {
        tf.delegate = self
        tf.placeholder = s
    }
    
    //入力された情報のリクエスト
    private func checkTextField(){
        if let user_identifier = userIdTF.text,
            let password = passwordTF.text {
                //非同期で情報を送って検証する
                UserFetcher(user_identifier: user_identifier, password: password).download{(result) -> Void in
                    if result == true {
                        //検証の成否で画面遷移をする
                        self.showTimeLine()
                    }
                }
        }
    }
    
    //タイムラインへの画面遷移
    private func showTimeLine(){
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarCtrl") as? TabBarController {
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }

}
