//
//  SignUpController.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/15.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit

class SignUpController: UIViewController, UITextInputTraits, UITextFieldDelegate {

    @IBOutlet weak var userIdTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBAction func backView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //入力したパスワードを見えないようにする
        passwordTF.secureTextEntry = true
        self.setReturnKeyType()
        self.setTextField(userIdTF, s: "ユーザIDを入力して下さい")
        self.setTextField(emailTF, s: "メールアドレスを入力して下さい")
        self.setTextField(userNameTF, s: "ユーザ名を入力して下さい")
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
        emailTF.returnKeyType = .Next
        userNameTF.returnKeyType = .Next
        passwordTF.returnKeyType = .Send
    }
    
    //テキストフィールドの基本設定
    private func setTextField(tf: UITextField, s: String) {
        tf.delegate = self
        tf.placeholder = s
    }
    
    //入力された情報のリクエスト
    private func checkTextField(){
        if let userId = userIdTF.text,
            let email = emailTF.text,
            let username = userNameTF.text,
            let password = passwordTF.text {
                //非同期で情報を送って検証する
                UserFetcher(userId: userId, password: password, username: username, email: email).download{(result) -> Void in
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
