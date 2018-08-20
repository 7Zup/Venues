//
//  DetailsModel.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 14/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation
import UIKit

enum Details {
    
    enum Get {
        
        struct Request {
            
            var venueId: String
        }
        
        struct Response {
            
            var venue: Venue
        }
        
        struct ViewModel {
            
            var name: String
            var rating: Double?
            var openUntil: String?
            var category: String?
            var icon: UIImage?
            var address: String?
        }
    }
    
    enum LaunchMap {
        
        struct Request {
        }
        
        struct Response {
            
            var launchDetails: LaunchDetails
        }
        
        struct ViewModel {
            
            var launchDetails: LaunchDetails
        }
        
        struct LaunchDetails {
            
            var name: String
            var lng: Double
            var lat: Double
        }
    }
}
