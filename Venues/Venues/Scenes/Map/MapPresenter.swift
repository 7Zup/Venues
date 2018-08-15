//
//  MapPresenter.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 14/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation
import UIKit

protocol MapPresentationLogic {
    
    func presentVenueList(response: Map.Search.Response)
}

class MapPresenter: MapPresentationLogic {
    
    weak var viewController: MapDisplayLogic?
    
    func presentVenueList(response: Map.Search.Response) {
        
        var viewModel: Map.Search.ViewModel
        var pinList: [Map.Search.ViewModel.Pin] = []
        
        for venue in response.venueList {
            
            if let id = venue.id, let prefix = venue.categories?.first?.icon?.prefix, let suffix = venue.categories?.first?.icon?.suffix, let lat = venue.location?.lat, let lng = venue.location?.lng {
                
                pinList.append(Map.Search.ViewModel.Pin(id: id, icon: prefix + "64" + suffix, lat: lat, lng: lng))
            }
        }
        
        viewModel = Map.Search.ViewModel(pinList: pinList)
        self.viewController?.displayPinList(viewModel: viewModel)
    }
}
