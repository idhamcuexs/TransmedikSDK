//
//  MapViewVC.swift
//  TransmedikSDK_Example
//
//  Created by Idham Kurniawan on 29/01/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import Mapbox
import Mapbox
import Alamofire

class MapViewVC: UIViewController,MGLMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var mapview: MGLMapView!
    let locationManager = CLLocationManager()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapview.styleURL = URL(string: "https://api.maptiler.com/maps/basic/style.json?key=Xf0TrAPcy6M36g1PqoSI")
            
              mapview.delegate = self
//              mapview.logoView.isHidden = true
//              mapview.attributionButton.isHidden = true
     
//        <key>NSLocationTemporaryUsageDescriptionDictionary</key>
//            <dict>
//                <key>MGLAccuracyAuthorizationDescription</key>
//                <string>Mapbox requires your precise location to help you navigate the map.</string>
//            </dict>
        
        if (CLLocationManager.locationServicesEnabled()) {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
            
            locationManager.startUpdatingLocation()
        }
   
    }
    
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
    
        let cordinat = mapview.centerCoordinate
        print("long => \(cordinat.longitude)")
        
//        https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&key=YOUR_API_KEY

    }
    
    func mapView(_ mapView: MGLMapView, regionWillChangeWith reason: MGLCameraChangeReason, animated: Bool) {
        print("akan berubah")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        mapview.setCenter(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), zoomLevel: 15, animated: true)
        locationManager.stopUpdatingLocation()
    }


}
