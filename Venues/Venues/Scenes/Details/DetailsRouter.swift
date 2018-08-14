//
//  DetailsRouter.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 14/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation
import UIKit

@objc protocol DetailsRoutingLogic {
}

protocol DetailsDataPassing {
    
    var data: DetailsData? { get }
}

class DetailsRouter: NSObject, DetailsRoutingLogic, DetailsDataPassing {
    
    weak var viewController: DetailsViewController?
    var data: DetailsData?
}
