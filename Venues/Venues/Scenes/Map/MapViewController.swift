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
import Cluster

protocol MapDisplayLogic: class {
    
    func displayPinList(viewModel: Map.Search.ViewModel)
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, MapDisplayLogic {
    
    var interactor: MapBusinessLogic?
    var router: (NSObjectProtocol & MapRoutingLogic & MapDataPassing)?
    
    // Map
    @IBOutlet var mapView: MKMapView!
    var locationManager: CLLocationManager!
    let clusterManager = ClusterManager()
    
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
        initClusterManager()
        
        self.updatePins()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        
        let regionRadius: CLLocationDistance = 250
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func initClusterManager() {
        
        self.clusterManager.minCountForClustering = 2
        self.clusterManager.maxZoomLevel = 16
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
        
        self.mapView.removeAnnotations(mapView.annotations)
        self.clusterManager.removeAll()
        
        for pin in viewModel.pinList {
            
            let annotation = CustomAnnotation(id: "id", thumbnailUrl: pin.icon, coordinate: CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.lng))
            
            clusterManager.add(annotation)
        }
        
        clusterManager.reload(mapView: mapView) { finished in
        }
    }
    
    // MARK: - MapView Delegate
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach { $0.alpha = 0 }
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            views.forEach { $0.alpha = 1 }
        }, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        
        if let cluster = annotation as? ClusterAnnotation {
            var zoomRect = MKMapRectNull
            for annotation in cluster.annotations {
                let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
                let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0)
                if MKMapRectIsNull(zoomRect) {
                    zoomRect = pointRect
                } else {
                    zoomRect = MKMapRectUnion(zoomRect, pointRect)
                }
            }
            mapView.setVisibleMapRect(zoomRect, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? ClusterAnnotation {
            
            let identifier = "Cluster"
            guard let style = annotation.style else {
                return nil
            }

            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if let view = view as? ClusterAnnotationView {
                view.annotation = annotation
                view.style = style
                view.image = UIImage(named: "pin")
                view.configure()
            } else {
                view = ClusterAnnotationView(annotation: annotation, reuseIdentifier: identifier, style: style)
            }
            return view
        } else {
            
            guard let annotation = annotation as? CustomAnnotation else {
                
                return nil
            }
            
            // Better to make this class property
            let identifier = "Pin"
            
            var annotationView: MKAnnotationView?
            if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                
                annotationView = dequeuedAnnotationView
                annotationView?.annotation = annotation
            }
            else {
                
                let av = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                annotationView = av
            }
            
            if let annotationView = annotationView {
                
                annotationView.canShowCallout = true
                
                // Resize image
                let size = CGSize(width: 30, height: 30)
                UIGraphicsBeginImageContext(size)
                
                guard let annotImage = annotation.image else { return nil }
                annotImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                let categorySized = UIGraphicsGetImageFromCurrentImageContext()
                
                annotationView.image = UIImage(named: "pin")!.imageOverlayingImages([categorySized!])
            }
            
            return annotationView
        }
        
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        self.updatePins()
    }
    
    func updatePins() {
        
        let center = mapView.centerCoordinate
        
        // TODO - Display when the "Refresh button" or search again is used
        
        // Make research regarding the center of the map
        self.interactor?.getVenueList(ll: "\(center.latitude),\(center.longitude)", radius: 250)
    }
    
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//
//        self.mapView.removeAnnotations(mapView.annotations)
//        let center = mapView.centerCoordinate
//
//        // TODO - Display when the "Refresh button" or search again is used
//
//        // Make research regarding the center of the map
//        self.interactor?.getVenueList(ll: "\(center.latitude),\(center.longitude)", radius: 250)
//
//        clusterManager.reload(mapView: mapView)
//    }
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
