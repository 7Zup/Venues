//
//  CustomAnnotation.swift
//  Venues
//
//  Created by Fabrice Froehly on 15/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import UIKit
import MapKit
import Cluster

class CustomAnnotation: NSObject, MKAnnotation {
    
    var id: String?
    var title: String?
    var imageView: UIImageView!
    var coordinate: CLLocationCoordinate2D
    var image: UIImage?
    var isSelected = false
    
    init(id: String, thumbnailUrl: String, coordinate: CLLocationCoordinate2D, title: String = "Title") {
        
        self.id = id
        self.title = title
        self.imageView = UIImageView()
        self.coordinate = coordinate
        
        if let image = try? UIImage(withContentsOfUrl: URL(string: thumbnailUrl)!) {
            self.image = image
        } else {
            self.image = nil
        }
    }
}
