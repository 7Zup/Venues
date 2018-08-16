//
//  ExMKMapView.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 16/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    
    func topCenterCoordinate() -> CLLocationCoordinate2D {
        
        return self.convert(CGPoint(x: self.frame.size.width / 2.0, y: 0), toCoordinateFrom: self)
    }
    
    func currentRadius() -> Int {
        
        let centerLocation = CLLocation(latitude: self.centerCoordinate.latitude, longitude: self.centerCoordinate.longitude)
        let topCenterCoordinate = self.topCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        return Int(centerLocation.distance(from: topCenterLocation))
    }
    
}
