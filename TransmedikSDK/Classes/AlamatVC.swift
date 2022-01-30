//
//  AlamatVC.swift
//  Pasien
//
//  Created by Idham Kurniawan on 29/01/22.
//

import UIKit
import Mapbox
import Alamofire
import SwiftyJSON

protocol AlamatVCDelegate {
    func getLocation (location : CLLocationCoordinate2D , address : String, note : String)
}

class AlamatVC: UIViewController,MGLMapViewDelegate,CLLocationManagerDelegate {
    
    
    
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var navBackground: UIView!
    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var viewNote: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var mapview: MGLMapView!
    @IBOutlet weak var note: UITextField!
    let locationManager = CLLocationManager()
    var coordinatLocation : CLLocationCoordinate2D?
    var delegate :AlamatVCDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapview.styleURL = URL(string: "https://api.maptiler.com/maps/basic/style.json?key=Xf0TrAPcy6M36g1PqoSI")
        mapview.delegate = self
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        viewDetail.isHidden.toggle()
        layoutSetup()
        
    }
    
    func layoutSetup(){
        navBackground.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        self.view.backgroundColor = Colors.backgroundmaster
        viewLoading.layer.cornerRadius = 13
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backOnCLick)))
        viewNote.layer.cornerRadius = 5
        viewAddress.layer.cornerRadius = 5
        viewNote.layer.borderWidth = 1
        viewNote.layer.borderColor = UIColor.lightGray.cgColor
        viewAddress.layer.borderWidth = 1
        viewAddress.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @objc func backOnCLick(){
        dismiss(animated: true, completion: nil)
    }
    
    func showInfo(){
        note.text = ""
        viewLoading.isHidden = true
        if viewDetail.isHidden{
            viewDetail.isHidden.toggle()
        }
        
    }
    
    func loadingViews(){
        viewLoading.isHidden = false
        if !viewDetail.isHidden{
            viewDetail.isHidden.toggle()
        }
    }
    
    func getDetailLocation(){
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(coordinatLocation?.latitude ?? 0.0),\(coordinatLocation?.longitude ?? 0.0)&key=YOUR_API_KEY"
        
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { respon in
                //                print(respon)
                
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    if json["code"].stringValue == "200"{
                        
                        self.showInfo()
                    }else{
                        
                        
                    }
                //                    print(value)
                case let .failure(error):
                    
                    break
                }
                
                
            }
    }
    
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        
        loadingViews()
        let cordinat = mapview.centerCoordinate
        
        coordinatLocation = CLLocationCoordinate2D(latitude: cordinat.latitude, longitude: cordinat.longitude)
        
//        getDetailLocation()
        showInfo()
        
        
    }
    
    func mapView(_ mapView: MGLMapView, regionWillChangeWith reason: MGLCameraChangeReason, animated: Bool) {
        if !viewDetail.isHidden{
            viewDetail.isHidden.toggle()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        coordinatLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        mapview.setCenter(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), zoomLevel: 15, animated: true)
        getDetailLocation()
        locationManager.stopUpdatingLocation()
    }
    
    
    
}
