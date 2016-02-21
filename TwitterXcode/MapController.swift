//
//  MapController.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/21.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapController: UIViewController, MKMapViewDelegate {

    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    @IBOutlet weak var postMV: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.postMV.delegate = self
        
        //テストのため
        /*
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        if let latitude = app.sharedUserData["latitude"] as? CLLocationDegrees,
            let longitude = app.sharedUserData["longitude"] as? CLLocationDegrees {
                self.latitude = latitude
                self.longitude = longitude
        } else {
        */    //
            self.latitude = 36.091274
            self.longitude = 140.109595
        //}
        
        //位置情報から地図を表示する
        let uco = CLLocationCoordinate2DMake(latitude, longitude)
        let rg = MKCoordinateRegionMakeWithDistance(uco, 3000, 3000)
        postMV.setRegion(rg, animated: false)
        
        //位置情報からピンを立てる
        let currentPin = MKPointAnnotation()
        currentPin.coordinate = uco
        currentPin.title = "現在地"
        if postMV.annotations.count != 0 {
            print("重複した古い現在地のピンを削除する：\(postMV.annotations[0].title)")
            postMV.removeAnnotation(postMV.annotations[0])
        }
        postMV.addAnnotation(currentPin)
        
        //initで初期化すると、argument errorになる
        let timeLineFetcher: TimeLineFetcher = TimeLineFetcher()
        timeLineFetcher.locationUpdate(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        timeLineFetcher.download{ (items) -> Void in
            self.arrangeMap(items)
        }
        
    }
    
    //
    func arrangeMap(postArray: [TimeLine]) {
        for var i = 0; i < postArray.count; i++ {
            if let latitude = postArray[i].latitude,
                let longitude = postArray[i].longitude {
                    let co = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let postPin = GeographicalTimeLine(post: postArray[i])
                    postPin.coordinate = co
                    self.postMV.addAnnotation(postPin)
            }
        }
    }
    
    //annotationの表示に関する設定をする
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "Pin"
        var pinview = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinview == nil {
            //pinを表示するためのViewを取得
            pinview = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            //pinのイベントを許可する
            pinview?.canShowCallout = true
            //pinをタップした時に出てくるポップアップの右側にボタンをつける
            pinview?.rightCalloutAccessoryView = UIButton(type: .InfoLight)
            
            if annotation.coordinate.latitude == latitude &&
                annotation.coordinate.longitude == longitude {
                pinview?.pinTintColor = UIColor.cyanColor()
            }
            
        } else {
            pinview!.annotation = annotation
        }
        return pinview
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //押されたのがポップアップの右側のボタンの場合
        if control == view.rightCalloutAccessoryView {
            //押されたボタンのAnnotationのクラスチェック
            switch NSStringFromClass(view.annotation!.dynamicType).componentsSeparatedByString(".").last! as String {
                
                case "GeographicalTimeLine":
                    //print((view.annotation as! GeographicalTimeLine).post)
                    //画面遷移する
                    if let post = (view.annotation as! GeographicalTimeLine).post {
                        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("TimeLineDetailCtrl") as? TimeLineDetailController {
                            vc.postArray.append(post)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                default: break
            }
        }
    }
    
}
