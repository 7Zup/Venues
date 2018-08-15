//
//  CustomAnnotation.swift
//  Venues
//
//  Created by Fabrice Froehly on 15/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage
import Cluster

class CustomAnnotation: NSObject, MKAnnotation {
    
    var id: String?
    var title: String?
    var imageView: UIImageView!
    var coordinate: CLLocationCoordinate2D
    var image: UIImage?
    
    init(id: String, thumbnailUrl: String, coordinate: CLLocationCoordinate2D, title: String = "") {
        
        self.id = id
        self.title = title
        self.imageView = UIImageView()
        self.coordinate = coordinate
        
//        self.imageView.sd_setImage(with: URL(string: thumbnailUrl), placeholderImage: UIImage(named: "pin"))
        if let image = try? UIImage(withContentsOfUrl: URL(string: thumbnailUrl)!) {
            self.image = image
        } else {
            self.image = nil
        }
    }
}

// UTILS -> TO BE REMOVED

extension UIImage {
    
    func imageOverlayingImages(_ images: [UIImage], scalingBy factors: [CGFloat]? = nil) -> UIImage {
        let size = self.size
        let container = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 2.0)
        UIGraphicsGetCurrentContext()!.interpolationQuality = .high
        
        self.draw(in: container)
        
        let scaleFactors = factors ?? [CGFloat](repeating: 1.0, count: images.count)
        
        for image in images {
            let topWidth = size.width / 3
            let topHeight = size.height / 3
            let topX = (size.width / 2.0) - (topWidth / 2.0)
            let topY = 35//(size.height / 2.0) - (topHeight / 2.0) + 18
            
            image.draw(in: CGRect(x: topX, y: CGFloat(topY), width: topWidth, height: topHeight), blendMode: .normal, alpha: 1.0)
        }
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}

extension UIImage {
    
    convenience init?(withContentsOfUrl url: URL) throws {
        let imageData = try Data(contentsOf: url)
        
        self.init(data: imageData)
    }
    
}
