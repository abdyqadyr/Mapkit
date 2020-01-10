//
//  File.swift
//  MapkitTask
//
//  Created by Abdykadyr Maksat on 02.11.19.
//  Copyright © 2019 Abdykadyr Maksat. All rights reserved.
//
import Foundation
import MapKit
class  LocationModel {
    let title: String?
    let subtitile: String?
    let long: Double?
    let latit: Double?
    let coordinates: MKPointAnnotation?
    
    init(title:String,subtitle: String, long: Double? , latit: Double?, coordinates: MKPointAnnotation) {
        self.title = title
        self.subtitile  = subtitle
        self.coordinates = coordinates
        self.latit = latit
        self.long = long
    }
    
    

}
