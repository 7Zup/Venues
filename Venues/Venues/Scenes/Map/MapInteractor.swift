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
        
        self.worker?.getVenueList(request: Map.Search.Request(urlParams: urlParams), completionHandler: venueListCompletionHandler, errorHandler: venuListErrorHandler)
    }
    
    func venueListCompletionHandler(response: VenueListResponse?) {

        if let venues = response?.response, let venueList = venues.venueList {
            
            self.presenter?.presentVenueList(response: Map.Search.Response(venueList: venueList))
        }
    }
    
    func venuListErrorHandler(error: Error) {
        
        print(error)
    }
}
