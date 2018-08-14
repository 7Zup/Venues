//
//  MapWorker.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 14/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation
import UIKit

protocol MapWorkerLogic {
    
    func getVenueList(urlParams: [String: String], completionHandler: @escaping ([Venue?]) -> Void, errorHandler: @escaping (Error) -> Void)
}

class MapWorker: MapWorkerLogic {
    
    var interactor: MapBusinessLogic?
    
    func getVenueList(urlParams: [String: String], completionHandler: @escaping ([Venue?]) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        APIManager.shared.requestArray(requestType: .get, urlParams: urlParams, route: "/search", completionHandler: completionHandler, errorHandler: errorHandler)
    }
}
