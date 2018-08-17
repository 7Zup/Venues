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
    
    func getVenue() {
        
        if let id = self.venueId {
         
            self.worker?.getVenue(request: Details.Get.Request(venueId: id), completionHandler: getVenueCompletionHandler, errorHandler: errorHandler)
        }
    }
    
    func getVenueCompletionHandler(response: VenueResponse?) {
        
        if let venueResponse = response?.response, let venueDetails = venueResponse.venue {

            self.presenter?.presentVenueDetails(response: Details.Get.Response(venue: venueDetails))
        }
    }
    
    func errorHandler(error: Error) {
        
        print("Error in DetailsInteractor: \(error)")
    }
}
