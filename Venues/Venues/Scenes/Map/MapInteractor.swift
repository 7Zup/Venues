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

    func getVenueList(with query: String?, ll: String, radius: Int)
    func updateSelectedId(with id: String?)
}

protocol MapData {
    
    var query: String? { get set }
    var selectedVenueId: String? { get set }
}

class MapInteractor: MapBusinessLogic, MapData {
    
    var presenter: MapPresentationLogic?
    var worker: MapWorker?
    
    var query: String?
    var selectedVenueId: String?
    
    // MARK: - Update seleted ID
    
    func updateSelectedId(with id: String?) {
        
        self.selectedVenueId = id
    }
    
    // MARK: - Get Venue List
    
    func getVenueList(with query: String?, ll: String, radius: Int = 250) {
        
        var urlParams = [String: String]()
        
        urlParams["ll"] = ll
        urlParams["radius"] = "\(radius)"
        urlParams["limit"] = "\(10)"
        if let query = query {
            
            urlParams["query"] = query
        }
        
        self.worker?.getVenueList(request: Map.Search.Request(urlParams: urlParams), completionHandler: venueListCompletionHandler, errorHandler: venueListErrorHandler)
    }
    
    func venueListCompletionHandler(response: VenueListResponse?) {

        if let venues = response?.response, let venueList = venues.venueList {
            
            self.presenter?.presentVenueList(response: Map.Search.Response(venueList: venueList))
        }
    }
    
    func venueListErrorHandler(error: Error) {
        
        print("Error in venueListErrorHandler: ", error)
    }
}
