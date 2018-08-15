//
//  VenueList.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 14/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation

struct VenueListResponse: Codable {
    
    var response: VenueList?
}

struct VenueList: Codable {

    var venueList: [Venue]?

    enum CodingKeys: String, CodingKey {

        case venueList = "venues"
    }
}
