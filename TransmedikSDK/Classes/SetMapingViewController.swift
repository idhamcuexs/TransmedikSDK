//
//  SetMapingViewController.swift
//  Pasien
//
//  Created by Idham Kurniawan on 22/12/21.
//  Copyright © 2021 Netkrom. All rights reserved.
//

import UIKit
//import GoogleMaps

import CoreLocation
//import GooglePlaces
import IQKeyboardManagerSwift

protocol  SetMapingViewControllerDelegate {
    func setLocation(long: Double , lat : Double, alamat : String, note : String)
}

class SetMapingViewController: MYUIViewController,CLLocationManagerDelegate,UITextViewDelegate {
    
    @IBOutlet weak var searchs: UITextField!
    @IBOutlet weak var viewtexts: UIView!
    @IBOutlet weak var viewsnotes: UIView!
//    @IBOutlet weak var mapview: GMSMapView!
    @IBOutlet weak var detailaddress: UILabel!
    @IBOutlet weak var note: UITextView!
    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var views: UIView!
    @IBOutlet weak var tetapkan: UIButton!
    @IBOutlet weak var tinggiNote: NSLayoutConstraint!
    
    
    var lat :Double?
    var long : Double?
    var selectedrow = 0
    var row = 0
    var tambah = true
    let locationManager = CLLocationManager()
//    let infoMarker = GMSMarker()
    var delegate : SetMapingViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        
    }
    
    func layout(){
//        mapview.delegate = self
        viewtexts.layer.cornerRadius = viewtexts.frame.height / 2
//        mapview.isMyLocationEnabled = true
        viewsnotes.layer.cornerRadius = 10
        tetapkan.layer.cornerRadius = 10
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        note.returnKeyType = .done
        note.delegate = self
        viewsnotes.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
//        viewtexts.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        viewtexts.layer.cornerRadius =  viewtexts.layer.frame.height / 2
        viewtexts.layer.borderWidth = 1
        viewtexts.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    @IBAction func chnge(_ sender: Any) {
        autocompleteClicked()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.layoutIfNeeded()
        print(textView.contentSize.height)
        tinggiNote.constant = textView.contentSize.height 
        
       
    
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if note.text == "Catatan"{
            note.text  = ""
            note.textColor  = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if note.text == ""{
            note.text  = "Catatan"
            note.textColor = .lightGray
        }
    }
    
    
    @IBAction func SendOnClick(_ sender: Any) {
        guard long != nil else {
            return
        }
        delegate?.setLocation(long: long!, lat: lat!, alamat: detailaddress.text ?? ""  , note: note.text)
        dismiss(animated: true, completion: nil)
    }
    
   
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                
        if textField == note{
            view.endEditing(true)
        }
        return true
    }
    
    
    @objc func kembali(){
        dismiss(animated: true, completion: nil)
    }
    
    
    func autocompleteClicked() {
//      let autocompleteController = GMSAutocompleteViewController()
//      autocompleteController.delegate = self
//
//      // Specify the place data types to return.
//      let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
//        UInt(GMSPlaceField.placeID.rawValue))!
//      autocompleteController.placeFields = fields
//
//      // Specify a filter.
//      let filter = GMSAutocompleteFilter()
//      filter.type = .address
//      autocompleteController.autocompleteFilter = filter
//
//      // Display the autocomplete view controller.
//      present(autocompleteController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        if (CLLocationManager.locationServicesEnabled()) {
//
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.requestWhenInUseAuthorization()
//            locationManager.startUpdatingLocation()
//        }
    }
    
    
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        if tambah{
//            let dd = GMSCameraPosition.camera(withLatitude: locations[0].coordinate.latitude, longitude:locations[0].coordinate.longitude, zoom: 20.0)
//            mapview.animate(to: dd)
//            mapview.settings.myLocationButton = true
//            mapview.isMyLocationEnabled = true
//            let position = CLLocationCoordinate2DMake(locations[0].coordinate.latitude,locations[0].coordinate.longitude)
//            let marker = GMSMarker(position: position)
//            marker.map = mapview
//            let geocoder = CLGeocoder()
//            geocoder.reverseGeocodeLocation(CLLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)) { (locstring, err) in
//                if let _ = err {
//                    return
//                }
//                let pm = locstring! as [CLPlacemark]
//
//                if pm.count > 0 {
//                    let pm = locstring![0]
//                    var addressString : String = ""
//                    if pm.subLocality != nil {
//                        addressString = addressString + pm.subLocality! + ", "
//                    }
//                    if pm.thoroughfare != nil {
//                        addressString = addressString + pm.thoroughfare! + ", "
//                    }
//                    if pm.locality != nil {
//                        addressString = addressString + pm.locality! + ", "
//                    }
//                    if pm.country != nil {
//                        addressString = addressString + pm.country! + ", "
//                    }
//                    if pm.postalCode != nil {
//                        addressString = addressString + pm.postalCode! + " "
//                    }
//
//                    self.detailaddress.text = addressString
//                    print(addressString)
//                }
//
//
//            }
//
//        }else{
//            let dd = GMSCameraPosition.camera(withLatitude: Double(alamatmodel.map_lat) ?? 0.0, longitude:Double(alamatmodel.map_lng) ?? 0.0, zoom: 20.0)
//            detailaddress.text = alamatmodel.address
//            long = Double(alamatmodel.map_lng) ?? 0.0
//            lat = Double(alamatmodel.map_lat) ?? 0.0
//            note.text = alamatmodel.note
//
//            mapview.animate(to: dd)
//            mapview.settings.myLocationButton = true
//            mapview.isMyLocationEnabled = true
//            let position = CLLocationCoordinate2DMake(Double(alamatmodel.map_lat) ?? 0.0,Double(alamatmodel.map_lng) ?? 0.0)
//            let marker = GMSMarker(position: position)
//            marker.map = mapview
//        }
//
//
//        locationManager.stopUpdatingLocation()
        
        
//    }
    
    
//    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
//        mapview.clear()
//        long = coordinate.longitude
//        lat = coordinate.latitude
//        let position = CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude)
//        let loc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(loc) { (locstring, err) in
//            if let _ = err {
//                return
//            }
//            let pm = locstring! as [CLPlacemark]
//
//            if pm.count > 0 {
//                let pm = locstring![0]
//                var addressString : String = ""
//                if pm.subLocality != nil {
//                    addressString = addressString + pm.subLocality! + ", "
//                }
//                if pm.thoroughfare != nil {
//                    addressString = addressString + pm.thoroughfare! + ", "
//                }
//                if pm.locality != nil {
//                    addressString = addressString + pm.locality! + ", "
//                }
//                if pm.country != nil {
//                    addressString = addressString + pm.country! + ", "
//                }
//                if pm.postalCode != nil {
//                    addressString = addressString + pm.postalCode! + " "
//                }
//
//                self.detailaddress.text = addressString
//
//                print(addressString)
//            }
//
//
//        }
//
//        let marker = GMSMarker(position: position)
//        marker.map = mapview
//    }
    
}


//extension SetMapingViewController : GMSMapViewDelegate{
//    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String,
//                 name: String, location: CLLocationCoordinate2D) {
//        print("You tapped \(name): \(placeID), \(location.latitude)/\(location.longitude)")
//
//        infoMarker.snippet = placeID
//        infoMarker.position = location
//        infoMarker.title = name
//        infoMarker.opacity = 0;
//        infoMarker.infoWindowAnchor.y = 1
//        infoMarker.map = mapView
//        mapview.selectedMarker = infoMarker
//
//    }
//
//
//
//
//}

//extension SetMapingViewController:GMSAutocompleteViewControllerDelegate{
//    // Handle the user's selection.
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//      print("Place name: \(place.name)")
//      print("Place ID: \(place.placeID)")
//        print("Place attributions: \(place.attributions)")
//        print("Place attributions: \(place.coordinate.longitude)")
//        print("Place attributions: \(place.viewport?.northEast.latitude)")
//
//
//
//        let placesClient = GMSPlacesClient()
//
//        // Specify the place data types to return.
//        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
//                        UInt(GMSPlaceField.coordinate.rawValue) |
//
//          UInt(GMSPlaceField.placeID.rawValue))!
//
//        placesClient.fetchPlace(fromPlaceID: place.placeID!, placeFields: fields, sessionToken: nil, callback: {
//          (places: GMSPlace?, error: Error?) in
//          if let error = error {
//            print("An error occurred: \(error.localizedDescription)")
//            return
//          }
//            self.dismissKeyboard()
//          if let places = places {
//
//            self.searchs.text = places.name ?? ""
//            print("The selected place is: \(places.coordinate)")
//
//
//            let dd = GMSCameraPosition.camera(withLatitude: places.coordinate.latitude + 0.0006, longitude: places.coordinate.longitude - 0.0006, zoom: 18.0)
//            self.mapview.animate(to: dd)
//          }
//        })
//
//      dismiss(animated: true, completion: nil)
//    }
//
//    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//      // TODO: handle the error.
//      print("Error: ", error.localizedDescription)
//    }
//
//    // User canceled the operation.
//    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//      dismiss(animated: true, completion: nil)
//    }
//
//    // Turn the network activity indicator on and off again.
//    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//      UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    }
//
//    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//      UIApplication.shared.isNetworkActivityIndicatorVisible = false
//    }
//
//}
