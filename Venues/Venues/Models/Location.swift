//
//  Location.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 14/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation

struct Location: Codable {
    
    var address: String?
    var crossStreet: String?
    var lat: Double?
    var lng: Double?
    var postalCode: String?
    var cc: String?
    var city: String?
    var state: String?
    var country: String?
}
