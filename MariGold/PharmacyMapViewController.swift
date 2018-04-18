//
//  PharmacyMapViewController.swift
//  MariGold
//
//  Created by Devin Sova on 4/18/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol HandleMapSearch {
	func dropPinZoomIn(placemark: MKPlacemark)
}

class PharmacyMapViewController: UIViewController, CLLocationManagerDelegate, HandleMapSearch, MKMapViewDelegate {
	
	@IBOutlet var mapView: MKMapView!
	let locationManager = CLLocationManager()
	var resultSearchController: UISearchController? = nil
	var selectedPin: MKPlacemark? = nil

	override func viewDidLoad() {
		super.viewDidLoad()
		
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		locationManager.requestLocation()
		
		let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
		resultSearchController = UISearchController(searchResultsController: locationSearchTable)
		resultSearchController?.searchResultsUpdater = locationSearchTable
		
		let searchBar = resultSearchController!.searchBar
		searchBar.sizeToFit()
		searchBar.placeholder = "Search for pharmacies"
		navigationItem.titleView = resultSearchController?.searchBar
		
		resultSearchController?.hidesNavigationBarDuringPresentation = false
		resultSearchController?.dimsBackgroundDuringPresentation = true
		definesPresentationContext = true
		
		locationSearchTable.mapView = mapView
		locationSearchTable.handleMapSearchDelegate = self
	}
	
	@objc func setPharmacy() {
		NSLog("42069696969")
	}
	
	/* HandleMapSearch Protocol Conform Methods
	--------------------------------------------- */
	func dropPinZoomIn(placemark: MKPlacemark) {
		
		selectedPin = placemark
		
		//Remove Current Annotations
		mapView.removeAnnotations(mapView.annotations)
		
		//Create new annotation with info
		let annotation = MKPointAnnotation()
		annotation.coordinate = placemark.coordinate
		annotation.title = placemark.name
		if let city = placemark.locality,
			let state = placemark.administrativeArea {
			annotation.subtitle = "\(city) \(state)"
		}
		mapView.addAnnotation(annotation)
		
		//Zoom into space
		let span = MKCoordinateSpanMake(0.05, 0.05)
		let region = MKCoordinateRegionMake(placemark.coordinate, span)
		mapView.setRegion(region, animated: true)
	}
	
	/* MKMapViewDelegate
	-------------------------------------- */
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKUserLocation {
			//Needed to draw Blue Dot indicating the User
			return nil
		}
		let reusePinID = "pin"
		var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reusePinID) as? MKPinAnnotationView
		pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reusePinID)
		pinView?.pinTintColor = UIColor.yellow
		pinView?.canShowCallout = true
		let smallSquare = CGSize(width: 30, height: 30)
		let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
		button.setBackgroundImage(#imageLiteral(resourceName: "Set"), for: .normal)
		button.addTarget(self, action: #selector(PharmacyMapViewController.setPharmacy), for: .touchUpInside)
		pinView?.leftCalloutAccessoryView = button
		return pinView
	}

	/* CLLocationManager Delegate Methods
	-------------------------------------- */
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedWhenInUse {
			locationManager.requestLocation()
		}
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			let span = MKCoordinateSpanMake(0.05, 0.05)
			let region = MKCoordinateRegion(center: location.coordinate, span: span)
			mapView.setRegion(region, animated: true)
			NSLog("CLLocationManager Location: \(location)")
		}
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		NSLog("CLLocationManager Error: \(error)")
	}
}
