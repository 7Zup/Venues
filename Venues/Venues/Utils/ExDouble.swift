//
//  ExDouble.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 20/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation

extension Double {
    
    /// Rounds the double to decimal places value
    func rounded(numberOfDecimalAfterComa: Int) -> Double {
        
        let divisor = pow(10.0, Double(numberOfDecimalAfterComa))
        return (self * divisor).rounded() / divisor
    }
}
