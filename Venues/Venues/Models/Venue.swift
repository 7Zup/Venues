//
//  Venue.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 14/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation

struct Venue: Codable {
    
    var id: String?
    var name: String?
    var contact: Contact?
    var location: Location?
    var categories: [Category]?
    var verified: Bool?
    var url: String?
    var hours: Hours?
    var rating: Float?
}
