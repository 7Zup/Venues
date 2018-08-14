//
//  Icon.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 14/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation

struct Icon: Codable {
    
    var prefix: String?
    var suffix: String?
    
    enum CodingKeys: String, CodingKey {
        
        case prefix
        case suffix
    }
}
