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
//    var ll: String?
//    var near: String?
//    var radius: Int?
//    var query: String?
//    var limit: Int?
    func getVenueList(ll: String, radius: Int)
}

protocol MapData {
    
    var query: String? {get set}
}

class MapInteractor: MapBusinessLogic, MapData {
    
    var presenter: MapPresentationLogic?
    var worker: MapWorker?
    
    var query: String?
    
    func getVenueList(ll: String, radius: Int = 250) {
        
        var urlParams = [String: String]()
        
        urlParams["ll"] = ll
        urlParams["radius"] = "\(radius)"
        urlParams["limit"] = "\(10)"
        
        self.worker?.getVenueList(urlParams: urlParams, completionHandler: venueListCompletionHandler, errorHandler: venuListErrorHandler)
    }
    
    func venueListCompletionHandler(venueList: [Venue?]) {
        
    }
    
    func venuListErrorHandler(error: Error) {
        
    }
}
