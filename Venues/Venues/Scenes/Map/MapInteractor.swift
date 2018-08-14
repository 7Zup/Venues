//
//  MapInteractor.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 14/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation
import UIKit

protocol MapBusinessLogic {
}

protocol MapData {
}

class MapInteractor: MapBusinessLogic, MapData {
    
    var presenter: MapPresentationLogic?
    var worker: MapWorker?
}
