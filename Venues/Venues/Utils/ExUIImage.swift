//
//  ExUIImage.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 16/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    convenience init?(withContentsOfUrl url: URL) throws {
        let imageData = try Data(contentsOf: url)
        
        self.init(data: imageData)
    }
    
    func imageOverlayingImages(_ images: [UIImage], scalingBy factors: [CGFloat]? = nil, marginTop: Int? = 0) -> UIImage {
        let size = self.size
        let container = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 2.0)
        UIGraphicsGetCurrentContext()!.interpolationQuality = .high
        
        self.draw(in: container)
        
        for image in images {
            let topWidth = size.width / 3
            let topHeight = size.height / 3
            let topX = (size.width / 2.0) - (topWidth / 2.0)
            let topY = marginTop
            
            image.draw(in: CGRect(x: topX, y: CGFloat(topY!), width: topWidth, height: topHeight), blendMode: .normal, alpha: 1.0)
        }
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    func tint(with color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        
        // flip the image
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -self.size.height)
        
        // multiply blend mode
        context.setBlendMode(.multiply)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context.fill(rect)
        
        // create UIImage
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

