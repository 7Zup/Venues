//
//  MapViewController.swift
//  Venues
//
//  Created by Fabrice FROEHLY on 14/08/2018.
//  Copyright © 2018 Fabrice FROEHLY. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol MapDisplayLogic: class {
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, MapDisplayLogic {
    
    var interactor: MapBusinessLogic?
    var router: (NSObjectProtocol & MapRoutingLogic & MapDataPassing)?
    
    // Map
    @IBOutlet var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
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
    }
    
    // MARK: - Initilize content
    
    // Setup all the parts of the VIP Architecture
    private func setup() {
        
        let viewController = self
        let interactor = MapInteractor()
        let presenter = MapPresenter()
        let router = MapRouter()
        let worker = MapWorker()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.data = interactor
    }
    
    private func initContent() {
        
        initLocation()
        initMapView()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        
        let regionRadius: CLLocationDistance = 250
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func initMapView() {
        
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    func initLocation() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
//            locationManager.startUpdatingHeading()
        }
    }
    
    // MARK: - Location Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        manager.stopUpdatingLocation()
        
        print("user ll = \(userLocation.coordinate.latitude) | \(userLocation.coordinate.longitude)")
//        mapView.setCenter(userLocation.coordinate, animated: true)
        centerMapOnLocation(location: userLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    // MARK: - MapView Delegate
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        var center = mapView.centerCoordinate
        print("map ll = \(center.latitude) | \(center.longitude)")
        
        // Display the "Refresh button" or search again
        self.interactor?.getVenueList(ll: "\(center.latitude),\(center.longitude)", radius: 250)
    }
}

extension MKMapView {
    
    func topCenterCoordinate() -> CLLocationCoordinate2D {
        
        return self.convert(CGPoint(x: self.frame.size.width / 2.0, y: 0), toCoordinateFrom: self)
    }
    
    func currentRadius() -> Double {
        
        let centerLocation = CLLocation(latitude: self.centerCoordinate.latitude, longitude: self.centerCoordinate.longitude)
        let topCenterCoordinate = self.topCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        return centerLocation.distance(from: topCenterLocation)
    }
    
}
