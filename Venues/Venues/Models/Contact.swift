//
//  Contact.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 14/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation

struct Contact: Codable {
    
    var phone: String?
    var formattedPhone: String?
    var twitter: String?
    var instagram: String?
    var facebook: String?
    var facebookUsername: String?
    var facebookName: String?
    
    enum CodingKeys: String, CodingKey {
        
        case phone
        case formattedPhone
        case twitter
        case instagram
        case facebook
        case facebookUsername
        case facebookName
    }
}
