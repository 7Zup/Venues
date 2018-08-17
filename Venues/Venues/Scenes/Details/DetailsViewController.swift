//
//  DetailsViewController.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 14/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation
import UIKit

protocol DetailsDisplayLogic: class {
    
    func displayVenueDetails(viewModel: Details.Get.ViewModel)
}

class DetailsViewController: UIViewController, DetailsDisplayLogic {
    
    var interactor: DetailsBusinessLogic?
    var router: (NSObjectProtocol & DetailsRoutingLogic & DetailsDataPassing)?
    
    @IBOutlet var whereView: UIView!
    @IBOutlet var goButton: UIButton!
    @IBOutlet var greyBackgroundView: UIView!
    
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var categoryImage: UIImageView!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var openUntilLabel: UILabel!
    
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.initContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Hide Navigation view controller
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.router?.notifyParentViewDismiss()
    }
    
    // MARK: - Initilize content
    
    // Setup all the parts of the VIP Architecture
    private func setup() {
        
        let viewController = self
        let interactor = DetailsInteractor()
        let presenter = DetailsPresenter()
        let router = DetailsRouter()
        let worker = DetailsWorker()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.data = interactor
    }
    
    private func initContent() {
        
        initViews()
        requestData()
    }
    
    func initViews() {
        
        // Round corner & shadow
        self.greyBackgroundView.roundCorner()
        self.greyBackgroundView.createShadow()
        
        // Round corner & shadow
        self.goButton.roundCorner()
        self.goButton.createShadow()
        
        // Round corner & shadow
        self.whereView.roundCorner()
    }
    
    func requestData() {
        
        self.interactor?.getVenue()
    }
    
    // MARK: - Obj Actions
    
    @IBAction func dismissViewBtnTD(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Protocol DisplayLogic
    
    func displayVenueDetails(viewModel: Details.Get.ViewModel) {

        self.addressLabel.text = viewModel.address
        self.nameLabel.text = viewModel.name
        self.categoryLabel.text = viewModel.category
        self.categoryImage.image = viewModel.icon
        self.ratingLabel.text = viewModel.rating
        self.openUntilLabel.text = viewModel.openUntil
    }
}
