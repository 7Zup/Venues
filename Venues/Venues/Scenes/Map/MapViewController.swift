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
    func deselectAnnotations()
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate, MapDisplayLogic {
    
    var interactor: MapBusinessLogic?
    var router: (NSObjectProtocol & MapRoutingLogic & MapDataPassing)?
    
    // Map
    @IBOutlet var mapView: MKMapView!
    var locationManager: CLLocationManager!
    let clusterManager = ClusterManager()
    
    @IBOutlet var refreshSearchButton: UIButton!
    var firstRefresh = true
    
    @IBOutlet var mapSearchBar: UISearchBar!
    
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
        
        self.hideKeyboardWhenTappedAround()
        
        // Init
        initRefreshBtn()
        initLocation()
        initMapView()
        initClusterManager()
    }
    
    func initRefreshBtn() {
        
        // Hide at first
        self.refreshSearchButton.alpha = 0.0
        
        // Shadow and Corner
        self.refreshSearchButton.createShadow()
        self.refreshSearchButton.roundCorner(radius: 19.0)
        
        self.firstRefresh = true
    }
    
    func initClusterManager() {
        
        self.clusterManager.minCountForClustering = 2
        self.clusterManager.maxZoomLevel = 16
        self.clusterManager.cellSize = 50
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
    
    // MARK: - Button Listener
    
    @IBAction func refreshBtnTUI(_ sender: Any) {
        
        self.updatePins()
    }
    
    // MARK: - Display Logic
    
    // Deselect annotation after DetailsView disappeared
    func deselectAnnotations() {
        
        for annotation in mapView.annotations {
         
            mapView.deselectAnnotation(annotation, animated: true)
        }
    }
    
    func displayPinList(viewModel: Map.Search.ViewModel) {
        
        self.mapView.removeAnnotations(mapView.annotations)
        self.clusterManager.removeAll()
        
        // Add each pin in mapView
        for pin in viewModel.pinList {
            
            let annotation = CustomAnnotation(id: pin.id, thumbnailUrl: pin.icon, coordinate: CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.lng))
            
            clusterManager.add(annotation)
        }
        clusterManager.reload(mapView, visibleMapRect: mapView.visibleMapRect)
        
        // Hide btn once the map has been refreshed
        refreshSearchButton.fadeOut()
    }
    
    // MARK: - SearchBar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // to limit network activity, reload half a second after last key press.
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.updatePins), object: nil)
        self.perform(#selector(self.updatePins), with: nil, afterDelay: 0.5)
    }
    
    // MARK: - Location Manager Delegate
    
    func centerMapOnLocation(location: CLLocation) {
        
        let regionRadius: CLLocationDistance = 250
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Center map on user just once
        manager.stopUpdatingLocation()
        
        if firstRefresh == true {
            
            centerMapOnLocation(location: userLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Error with laction manager: \(error)")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
    }
    
    // MARK: - MapView Functions
    
    // Resize image
    func resizeImage(image:UIImage, scaledToSize newSize: CGSize) -> UIImage{
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    // Concat pin + category's icon
    func getBigAnnotationImage(annotation: CustomAnnotation) -> UIImage {
        
        return resizeImage(image: UIImage(named: "pin")!, scaledToSize: CGSize(width: 80, height: 80)).imageOverlayingImages([resizeImage(image: annotation.image!, scaledToSize: CGSize(width: 35, height: 35))], marginTop: 45)
    }
    
    // Concat pin + category's icon
    func getSmallAnnotationImage(annotation: CustomAnnotation) -> UIImage {
        
        return resizeImage(image: UIImage(named: "pin")!, scaledToSize: CGSize(width: 50, height: 50)).imageOverlayingImages([resizeImage(image: annotation.image!, scaledToSize: CGSize(width: 30, height: 30))], marginTop: 27)
    }
    
    // MARK: - MapView Delegate
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach { $0.alpha = 0 }
        UIView.animate(withDuration: 0.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            views.forEach { $0.alpha = 1 }
        }, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        guard let annotation = view.annotation else { return }

        if let annotation = annotation as? CustomAnnotation {
            
            view.image = getSmallAnnotationImage(annotation: annotation)
        }
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
        else if let annotation = annotation as? CustomAnnotation {
            
            view.image = getBigAnnotationImage(annotation: annotation)
            self.interactor?.updateSelectedId(with: annotation.id)
            self.refreshSearchButton.alpha = 0.0
            self.router?.routeToModalDetail()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // If the annotation is a cluster
        if let annotation = annotation as? ClusterAnnotation {
            
            let identifier = "Cluster"
            
            guard let style = annotation.style else { return nil }

            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if let view = view as? ClusterAnnotationView {
                view.annotation = annotation
                view.configure(with: view.style)
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
                
                annotationView.canShowCallout = false

                // Resize both image and add one over the other to make a marker + the proper icon
                annotationView.image = getSmallAnnotationImage(annotation: annotation)
            }
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        if firstRefresh == true {
            
            // Update pins without displaying button the first time
                self.updatePins()
                    firstRefresh = false
        } else {
            
            // Make refresh btn appear
            self.refreshSearchButton.fadeIn()
        }
        
        // Refresh clusters to regroup pins even if they are not being updated
        clusterManager.reload(mapView, visibleMapRect: mapView.visibleMapRect)
    }
    
    @objc func updatePins() {
        
        let center = mapView.centerCoordinate
        self.interactor?.getVenueList(with: self.mapSearchBar.text, ll: "\(center.latitude),\(center.longitude)", radius: mapView.currentRadius())
    }
}
