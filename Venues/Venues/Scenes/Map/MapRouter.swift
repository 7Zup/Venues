//
//  MapRouter.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 14/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation
import UIKit
import Presentr

@objc protocol MapRoutingLogic {
    
    func routeToModalDetail()
}

protocol MapDataPassing {
    
    var data: MapData? { get }
}

class MapRouter: NSObject, MapRoutingLogic, MapDataPassing {
    
    weak var viewController: MapViewController?
    var data: MapData?
    
    // Lib to display modal easily
    let presenter: Presentr = {
        let width = ModalSize.full
        let height = ModalSize.full
        let center = ModalCenterPosition.center
        let customType = PresentationType.custom(width: width, height: height, center: center)
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = TransitionType.coverVertical
        customPresenter.dismissTransitionType = TransitionType.coverVertical
        customPresenter.roundCorners = false
        customPresenter.backgroundOpacity = 0.0
        customPresenter.dismissOnSwipe = true
        customPresenter.dismissOnSwipeDirection = DismissSwipeDirection.default
        return customPresenter
    }()
    
    // MARK: - Information
    
    func routeToModalDetail() {
        
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        var destinationDS = destinationVC.router!.data!
        
        // Pass data from one scene to another
        passDataToUserList(source: data!, destination: &destinationDS)
        
        // Perform navigation
        navigateToInformation(source: viewController!, destination: destinationVC)
    }
    
    private func navigateToInformation(source: MapViewController, destination: DetailsViewController) {
        
        source.customPresentViewController(presenter, viewController: destination, animated: true, completion: nil)
    }
    
    private func passDataToUserList(source: MapData, destination: inout DetailsData) {
        
        //        destination.user = source.user
        //        destination.event = source.event
    }
}
