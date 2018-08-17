//
//  DetailsRouter.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 14/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation
import UIKit

@objc protocol DetailsRoutingLogic {
    
    func notifyParentViewDismiss()
}

protocol DetailsDelegate {
    
    func detailViewDisappeared()
}

protocol DetailsDataPassing {
    
    var data: DetailsData? { get set }
}

class DetailsRouter: NSObject, DetailsRoutingLogic, DetailsDataPassing {
    
    weak var viewController: DetailsViewController?
    var data: DetailsData?
    
    // Call parent to dimiss view
    func notifyParentViewDismiss() {
        
        if let delegate = data?.detailsDelegate {
            
            delegate.detailViewDisappeared()
        }
    }
}
