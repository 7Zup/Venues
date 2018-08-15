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
    
    func displayPinList(viewModel: Map.Search.ViewModel)
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
        }
    }
    
    // MARK: - Location Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        manager.stopUpdatingLocation()
        
        print("user ll = \(userLocation.coordinate.latitude) | \(userLocation.coordinate.longitude)")
        centerMapOnLocation(location: userLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    // MARK: - Display Logic
    
    func displayPinList(viewModel: Map.Search.ViewModel) {
        
        for pin in viewModel.pinList {
            
//            "https://api.adorable.io/avatars/285/abott@adorable.png"
            
            let annotation = CustomAnnotation(id: "id", thumbnailUrl: pin.icon, coordinate: CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.lng))
            
//            annotation.coordinate = CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.lng)

            mapView.addAnnotation(annotation)
        }
    }
    
    // MARK: - MapView Delegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? CustomAnnotation else { return nil }
     
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {

            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {

            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        
        if let annotationView = annotationView {

            annotationView.canShowCallout = true

            // Resize image
            var size = CGSize(width: 50, height: 50)
            UIGraphicsBeginImageContext(size)
            annotation.image!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let categorySized = UIGraphicsGetImageFromCurrentImageContext()
            
//            size = CGSize(width: 50, height: 50)
//            UIImage(named: "pin")!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//            let pinSized = UIGraphicsGetImageFromCurrentImageContext()
            
            annotationView.image = UIImage(named: "pin")!.imageOverlayingImages([categorySized!])
            
//             = resizedImage
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        self.mapView.removeAnnotations(mapView.annotations)
        let center = mapView.centerCoordinate
        
        // TODO - Display when the "Refresh button" or search again is used
        
        // Make research regarding the center of the map
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
