//
//  MapModels.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 14/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation
import UIKit

enum Map {
    
    enum Search {
        
        struct Request {
            
            var urlParams: [String: String]
        }
        
        struct Response {
            
            var venueList: [Venue]
        }
        
        struct ViewModel {
            
            struct Pin {
                
                var id: String
                var icon: String
                var lat: Double
                var lng: Double
            }
            
            var pinList: [Pin]
        }
    }
}
