//
//  PostControllerViewController.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/16.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit
import AVFoundation

class PostController: UIViewController, UITabBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var receiver_post:TimeLine?
    var image_url: String = ""
    private var latitude: Double?
    private var longitude: Double?
    
    @IBOutlet weak var postTV: UITextView!
    @IBOutlet weak var postIV: UIImageView!
    @IBOutlet weak var selectImageTB: UITabBar!
    @IBOutlet weak var photoHeight: NSLayoutConstraint!
    
    //投稿する画像を選択する際に必要な処理をする
    private func setPhoto(imagePath: String){
        //privateにしていると既にインスタンスが生成されているので、代入できない
        self.image_url = imagePath
        postIV.image = UIImage(named:imagePath)
        
        if let photoSize = postIV.image?.size {
            //写真を当てはめる枠となる領域
            let boundingRect =  CGRect(x: 0, y: 0, width: CGFloat(self.view.bounds.width - 140), height: CGFloat(self.view.bounds.height - 282))
            //枠となる領域にAspectRatioで写真を当てはめた時の写真の領域を返す
            let rect  = AVMakeRectWithAspectRatioInsideRect(photoSize, boundingRect)
            photoHeight.constant = rect.size.height
        } else {
            photoHeight.constant = CGFloat(0)
        }
    }
    
    @IBAction func backView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func postUpload(sender: AnyObject) {
        if let latitude = self.latitude,
            let longitude = self.longitude,
            let text = postTV.text {
                let post = PostWrapper.getInstance(["text": text, "image_url": image_url, "latitude": latitude, "longitude": longitude])
                //正しく初期化されていないとnilを返している
                if let post = post {
                    if post.image_url != nil {
                        //画像ありの場合
                        PostDispatcher(post: post, receiver_post: receiver_post).uploadWithImage{(result) -> Void in
                            if result {
                                print("画像とテキストの投稿が完了しました")
                            } else {
                                print("画像とテキストの投稿が失敗しました")
                            }
                        }
                    } else {
                        //画像無しの場合
                        PostDispatcher(post: post, receiver_post: receiver_post).upload{(result) -> Void in
                            if result {
                                print("テキストの投稿が完了しました")
                            } else {
                                print("テキストの投稿が失敗しました")
                            }
                        }
                    }
                }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectImageTB.delegate = self
        
        photoHeight.constant = CGFloat(0)
        
        if let username = receiver_post?.username {
            postTV.text = "Dear: \(username)"
        }
        
        //取得した位置情報を設定する
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        if let latitude = app.sharedUserData["latitude"] as? Double,
            let longitude = app.sharedUserData["longitude"] as? Double {
                self.latitude = latitude
                self.longitude = longitude
                print("ユーザの投稿時の緯度経度：\(latitude), \(longitude)")
        }
    }
    
    //押されたタブをタグで識別して処理を分ける
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        switch item.tag {
        case 0:
            self.setPhoto("Image02.jpg")
        case 1:
            //カメラロールへアクセス
            self.pickImageFromLibrary()
        default:
            print("item.tag:\(item.tag)")
        }
    }
    
    //ライブラリから写真を選択する
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    //写真を選択した時に呼ばれる
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            if let assetURL:AnyObject = info[UIImagePickerControllerReferenceURL] {
                print(String(assetURL))
                //self.setPhoto(imageのPath)
                //このURLを取り出すにはAssetLibrary.Frameworkが必要になる
            }
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }




}
