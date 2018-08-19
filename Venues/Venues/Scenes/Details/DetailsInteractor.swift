//
//  DetailsInteractor.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 14/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation
import UIKit

protocol DetailsBusinessLogic {
    
    func getVenue()
    func tryToLaunchMaps()
}

protocol DetailsData {
    
    var detailsDelegate: DetailsDelegate? { get set }
    var venueId: String? { get set }
}

class DetailsInteractor: DetailsBusinessLogic, DetailsData {
    
    var presenter: DetailsPresentationLogic?
    var worker: DetailsWorker?
    var detailsDelegate: DetailsDelegate?
    var venueId: String?
    var lastVenue: Venue?
    
    func getVenue() {
        
        if let id = self.venueId {
         
            self.worker?.getVenue(request: Details.Get.Request(venueId: id), completionHandler: getVenueCompletionHandler, errorHandler: errorHandler)
        }
    }
    
    func getVenueCompletionHandler(response: VenueResponse?) {
        
        if let venueResponse = response?.response, let venueDetails = venueResponse.venue {

            self.lastVenue = venueDetails
            self.presenter?.presentVenueDetails(response: Details.Get.Response(venue: venueDetails))
        }
    }
    
    func errorHandler(error: Error) {
        
        print("Error in DetailsInteractor: \(error)")
    }
    
    // MARK: - Try to launch maps
    
    func tryToLaunchMaps() {
        
        if let venue = self.lastVenue, let name = venue.name, let lng = venue.location?.lng, let lat = venue.location?.lat {
            
            self.presenter?.presentMaps(response: Details.LaunchMap.Response(launchDetails: Details.LaunchMap.LaunchDetails(name: name, lng: lng, lat: lat)))
        }
    }
}
