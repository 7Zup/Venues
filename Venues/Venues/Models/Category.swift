//
//  Categorie.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 14/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation

struct Category: Codable {
    
    var id: String?
    var name: String?
    var pluralName: String?
    var shortName: String?
    var icon: Icon?
    var primary: Bool?
   
    enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case pluralName
        case shortName
        case icon
        case primary
    }
}
