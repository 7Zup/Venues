//
//  DetailsPresenter.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 14/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation
import UIKit

protocol DetailsPresentationLogic {
    
    func presentVenueDetails(response: Details.Get.Response)
}

class DetailsPresenter: DetailsPresentationLogic {
    
    weak var viewController: DetailsDisplayLogic?
    
    func presentVenueDetails(response: Details.Get.Response) {
        
        let appColor = UIColor.init(rgb: 0xE54B68)
        
        if let name = response.venue.name {
            
            var address = "Unknown Address"
            var rating = "No rating for now"
            var openUntil = "This venue has no schedule yet"
            var type = "Unknown type"
            var icon: Icon?
            var image: UIImage = UIImage(named: "unknown")!
            
            if let categories = response.venue.categories, categories.count >= 1, let catType = categories[0].name, let catIcon = categories[0].icon {
                
                type = catType
                icon = catIcon
                
                if let prefix = icon?.prefix, let suffix = icon?.suffix, let url =  URL(string: "\(prefix)64\(suffix)"), let venueImage = try? UIImage(withContentsOfUrl: url) {
                    
                    image = venueImage!
                }
            }
            
            if let venueRating = response.venue.rating {
                
                rating = "\(venueRating) / 10"
            }
            
            if let venueOpenUntil = response.venue.hours?.status {
                
                openUntil = venueOpenUntil
            } else if let venueOpen = response.venue.hours?.isOpen {
                
                if venueOpen {
                    
                    openUntil = "Open today"
                } else {
                    
                    openUntil = "Closed today"
                }
            }
            
            if let venueAddress = response.venue.location?.address, let venueCity = response.venue.location?.city {
                
                address = venueAddress + ", " + venueCity
            }
            
            let viewModel = Details.Get.ViewModel(name: name, rating: rating, openUntil: openUntil, category: type, icon: image.tint(with: appColor), address: address)
            self.viewController?.displayVenueDetails(viewModel: viewModel)
        }
    }
}

