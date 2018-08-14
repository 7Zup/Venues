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
            
            var ll: String?
            var near: String?
            var radius: Int?
            var query: String?
            var limit: Int?
        }
        
        struct Response {
            
            var venueList: [Venue]
        }
        
        struct ViewModel {
            
            var venueList: [Venue]
        }
    }
}
