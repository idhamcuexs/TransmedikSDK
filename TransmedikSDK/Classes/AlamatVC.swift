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

struct ResponsePlancesMod: Codable {
    var results : [AddressMod]?
}

struct AddressMod  : Codable{
    var formatted_address : String?
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
    @IBOutlet weak var saveButton: UIButton!
    let locationManager = CLLocationManager()
    var coordinatLocation : CLLocationCoordinate2D?
    var delegate :AlamatVCDelegate?
    var getfirst = false
    var getdata = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapview.styleURL = URL(string: "https://api.maptiler.com/maps/basic/style.json?key=Xf0TrAPcy6M36g1PqoSI")
        mapview.delegate = self
       
//        viewDetail.isHidden.toggle()
        layoutSetup()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func layoutSetup(){
        navBackground.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        viewDetail.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        self.view.backgroundColor = Colors.backgroundmaster
        viewLoading.layer.cornerRadius = 13
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backOnCLick)))
        viewNote.layer.cornerRadius = 10
        viewAddress.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 20
        viewNote.layer.borderWidth = 1
        viewNote.layer.borderColor = UIColor.lightGray.cgColor
        viewAddress.layer.borderWidth = 1
        viewAddress.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    @IBAction func saveOnClick(_ sender: Any) {
        
        
        guard coordinatLocation != nil else {
            return
        }
        if address.text ?? "" != ""{
            dismiss(animated: true, completion: nil)
            delegate?.getLocation(location: coordinatLocation!, address: address.text!, note: note.text ?? "")

        }

    }
    
    @objc func backOnCLick(){
        dismiss(animated: true, completion: nil)
    }
//
//    func showInfo(){
//        viewLoading.isHidden = true
//        if viewDetail.isHidden{
//            viewDetail.isHidden.toggle()
//        }
//
//    }
//
//    func loadingViews(){
//        viewLoading.isHidden = false
//        if !viewDetail.isHidden{
//            viewDetail.isHidden.toggle()
//        }
//    }
//
    func getDetailLocation(){
        guard !getdata else {
            return
        }
        getdata = true
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(coordinatLocation?.latitude ?? 0.0),\(coordinatLocation?.longitude ?? 0.0)&key=AIzaSyDYhPXYjgCmT7ZO8jZigFm8iPXY_e16C8M"
        
        viewLoading.isHidden = false
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { respon in
                                 print(respon)
                
                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    do{
                        let result = try JSONDecoder().decode(ResponsePlancesMod.self, from: json.rawData())
                        print("masuks")
                        print(result.results?.count)
//                        self.showInfo()
                        self.viewLoading.isHidden = true

                        self.address.text = result.results![0].formatted_address ?? ""
                        self.note.text = ""
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.getfirst = true
                            self.getdata = false
                        }

                    }catch{
                        print("error Model")
                    }
                    
                //                    print(value)
                case let .failure(error):
                    
                    break
                }
                
                
            }
    }
    
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        
        guard getfirst else {return}
//        loadingViews()
        let cordinat = mapview.centerCoordinate
        print("cek 3")
        coordinatLocation = CLLocationCoordinate2D(latitude: cordinat.latitude, longitude: cordinat.longitude)
//
        getDetailLocation()
        
        
    }
    
    func mapView(_ mapView: MGLMapView, regionWillChangeWith reason: MGLCameraChangeReason, animated: Bool) {
    
        
//        guard getdata else {
//            return
//        }
//
//        guard getfirst else {
//            return
//        }
//        if !viewDetail.isHidden{
//            viewDetail.isHidden.toggle()
//        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        coordinatLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        mapview.setCenter(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), zoomLevel: 15, animated: true)
        getDetailLocation()
//        print("cek 1")
        locationManager.stopUpdatingLocation()
    }
    
    
    
}
