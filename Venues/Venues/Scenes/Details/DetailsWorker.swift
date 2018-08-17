
//
//  DetailsWorker.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 14/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation
import UIKit

protocol DetailsWorkerLogic {
    
    func getVenue(request: Details.Get.Request, completionHandler: @escaping (VenueResponse?) -> Void, errorHandler: @escaping (Error) -> Void)
}

class DetailsWorker: DetailsWorkerLogic {
    
    var interactor: DetailsBusinessLogic?
    
    func getVenue(request: Details.Get.Request, completionHandler: @escaping (VenueResponse?) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        APIManager.shared.request(requestType: .get, urlParams: [:], route: "/\(request.venueId)", completionHandler: completionHandler, errorHandler: errorHandler)
    }
}
