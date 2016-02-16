//
//  TimeLineTabBarControllerViewController.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/15.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import UIKit
import CoreLocation

class TabBarController: UITabBarController, CLLocationManagerDelegate {

    private let app = UIApplication.sharedApplication().delegate as! AppDelegate
    private var lm: CLLocationManager!
    private var latitude: CLLocationDegrees!
    private var longitude: CLLocationDegrees!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lm = CLLocationManager()
        longitude = CLLocationDegrees()
        latitude = CLLocationDegrees()
        
        lm.delegate = self
        //位置情報取得の許可
        lm.requestAlwaysAuthorization()
        //位置情報の精度
        lm.desiredAccuracy = kCLLocationAccuracyBest
        //指定した値分移動したら位置情報を更新する
        lm.distanceFilter = 500
        //GPSの使用を開始する
        lm.startUpdatingLocation()
        
    }
    
    //位置情報取得成功時に実行
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        latitude = Double(newLocation.coordinate.latitude)
        longitude = Double(newLocation.coordinate.longitude)
        app.sharedUserData["latitude"] = latitude
        app.sharedUserData["longitude"] = longitude
        print("ユーザの現在地の緯度経度: \(latitude),\(longitude)")
    }
    
    //位置情報取得失敗時に実行
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("ErrorDomain: \(error.domain)")
        print("ErrorCode: \(error.code)")
    }
    
}
