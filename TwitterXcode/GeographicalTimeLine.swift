//
//  GeographicalTimeLine.swift
//  TwitterXcode
//
//  Created by 今村翔一 on 2016/02/21.
//  Copyright © 2016年 今村翔一. All rights reserved.
//

import MapKit
import CoreLocation

class GeographicalTimeLine: MKPointAnnotation {
    
    var post:TimeLine?
    
    init(post: TimeLine) {
        super.init()
        self.post = post
        self.subtitle = post.username
        self.title = post.text
    }
}
