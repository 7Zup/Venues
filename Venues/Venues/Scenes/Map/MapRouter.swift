//
//  MapRouter.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 14/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation
import UIKit

@objc protocol MapRoutingLogic {
}

protocol MapDataPassing {
    
    var data: MapData? { get }
}

class MapRouter: NSObject, MapRoutingLogic, MapDataPassing {
    
    weak var viewController: MapViewController?
    var data: MapData?
}
