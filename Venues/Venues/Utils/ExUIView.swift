//
//  ExUIView.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 16/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func fadeIn() {
        
        // Move our fade out code from earlier
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func fadeOut() {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
    
    func createShadow() {
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 2.0
        self.layer.cornerRadius = 5.0
    }
    
    func roundCorner(radius: CGFloat? = 5.0) {
        
        self.layer.cornerRadius = radius!
    }
}
