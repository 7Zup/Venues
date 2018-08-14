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
}

protocol DetailsData {
}

class DetailsInteractor: DetailsBusinessLogic, DetailsData {
    
    var presenter: DetailsPresentationLogic?
    var worker: DetailsWorker?
}
