//
//  AlamatVC.swift
//  Pasien
//
//  Created by Idham Kurniawan on 29/01/22.
//

import UIKit
//import Mapbox
import Alamofire
import SwiftyJSON
import MapKit
import SkeletonView


//
protocol AlamatVCDelegate {
    func getLocation (location : CLLocationCoordinate2D , address : String, note : String)
}

struct ResponsePlancesMod: Codable {
    var results : [AddressMod]?
}

struct AddressMod  : Codable{
    var formatted_address : String?
}


struct ResponseSearchPlance: Codable {
    var results : [SearchMod]?
}
struct SearchMod :  Codable {
    var formatted_address : String?
    var geometry: SearchLocationGeometryMod?

}

struct SearchLocationGeometryMod :  Codable {
    var location : SearchLocationMod?
}


struct SearchLocationMod :  Codable {
    var lat,lng : Double?
}


class AlamatVC: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {


    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var search: UITextField!
    
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var tableSearch: UITableView!
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var navBackground: UIView!
    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var viewNote: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var note: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    let locationManager = CLLocationManager()
    var coordinatLocation : CLLocationCoordinate2D?
    var delegate :AlamatVCDelegate?
    var getfirst = false
    var getdata = false
    var dataSearch = [SearchMod]()
    var searchTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
//        mapview.styleURL = URL(string: "https://api.maptiler.com/maps/basic/style.json?key=Xf0TrAPcy6M36g1PqoSI")
        map.delegate = self

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
    @IBAction func changeSearch(_ sender: Any) {
        tableSearch.showGradientSkeleton()
        if search.text == ""{
            tableSearch.isHidden = true
        }else{
            tableSearch.isHidden = false
        }
        // if a timer is already active, prevent it from firing
            if searchTimer != nil {
                searchTimer?.invalidate()
                searchTimer = nil
            }

            // reschedule the search: in 1.0 second, call the searchForKeyword method on the new textfield content
            searchTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(searchForKeyword(_:)), userInfo: search.text!, repeats: false)
        }

        @objc func searchForKeyword(_ timer: Timer) {

            // retrieve the keyword from user info
            guard search.text != "" else {
                return
            }
            let keyword = timer.userInfo!
            searchPlance()
//            print("Searching for keyword \(keyword)")
        }

        
        
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool){
//        print("The \(mapView.centerCoordinate.latitude)")
//       print("the maprect \(mapView.visibleMapRect.origin)")
//       print("the maprect \(mapView.visibleMapRect.size)")
//       //I find just this attributes for mapView

        guard getfirst else {return}
//
        let cordinat = mapView.centerCoordinate
//        print("cek 3")
        coordinatLocation = CLLocationCoordinate2D(latitude: cordinat.latitude, longitude: cordinat.longitude)
//
        getDetailLocation()
       }
    
    
    func layoutSetup(){
        tableSearch.isHidden = true

        navBackground.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        viewDetail.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        self.view.backgroundColor = Colors.backgroundmaster
        viewLoading.layer.cornerRadius = 13
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backOnCLick)))
        viewNote.layer.cornerRadius = 10
        viewSearch.layer.cornerRadius = 10
        viewAddress.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 20
        viewNote.layer.borderWidth = 1
        viewNote.layer.borderColor = UIColor.lightGray.cgColor
        viewAddress.layer.borderWidth = 1
        viewAddress.layer.borderColor = UIColor.lightGray.cgColor
        viewSearch.layer.borderWidth = 1
        viewSearch.layer.borderColor = UIColor.lightGray.cgColor
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

    func getDetailLocation(){
        guard !getdata else {
            return
        }
        getdata = true
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(coordinatLocation?.latitude ?? 0.0),\(coordinatLocation?.longitude ?? 0.0)&key=AIzaSyDYhPXYjgCmT7ZO8jZigFm8iPXY_e16C8M"

        viewLoading.isHidden = false
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { respon in
//                                 print(respon)

                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    do{
                        let result = try JSONDecoder().decode(ResponsePlancesMod.self, from: json.rawData())
//                        print("masuks")
//                        print(result.results?.count)
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

    
    @IBAction func endTypingSearch(_ sender: Any) {
        searchPlance()
    }
    
    func searchPlance(){
        
        guard let cari = search.text else{return}

        let url = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(cari.replacingOccurrences(of: " ", with: "%20"))&key=AIzaSyDYhPXYjgCmT7ZO8jZigFm8iPXY_e16C8M"
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { respon in
//                                 print(respon)

                switch respon.result {
                case let .success(value):
                    let json = JSON(value)
                    do{
                        let result = try JSONDecoder().decode(ResponseSearchPlance.self, from: json.rawData())
                        self.dataSearch = result.results!
                        self.tableSearch.hideSkeleton()
                        self.tableSearch.reloadData()
                    

                    }catch{
                        print("error Model")
                    }
                    
//                    ResponseSearchPlance
                case let .failure(error):

                    break
                }


            }
    }

//    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
//
//        guard getfirst else {return}
////        loadingViews()
//        let cordinat = mapview.centerCoordinate
//        print("cek 3")
//        coordinatLocation = CLLocationCoordinate2D(latitude: cordinat.latitude, longitude: cordinat.longitude)
////
//        getDetailLocation()
////
//
//    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        coordinatLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        render(getDetail: true)
        locationManager.stopUpdatingLocation()
    }

    
    func render(getDetail : Bool){
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinatLocation!, span: span)
        map.setRegion(region, animated: true)
        if getDetail{
            getDetailLocation()
        }
       
        
    }


}

extension AlamatVC : UITableViewDataSource,UITableViewDelegate,SkeletonTableViewDelegate,SkeletonTableViewDataSource{
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return ListSearchPlanceTableViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListSearchPlanceTableViewCell.identifier, for: indexPath) as! ListSearchPlanceTableViewCell
        cell.name.text = dataSearch[indexPath.row].formatted_address ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lokasi = dataSearch[indexPath.row].geometry
//        print(lokasi!.lat)
//        print(lokasi!.lng)
//
//        coordinatLocation = CLLocationCoordinate2D(latitude: Double(lokasi!.location!.lat!)!, longitude: Double(lokasi!.location!.lng!)!)
        coordinatLocation = CLLocationCoordinate2D(latitude: lokasi!.location!.lat!, longitude: lokasi!.location!.lng!)
        render(getDetail: false)
        tableSearch.isHidden = true
        search.text = ""
        self.view.endEditing(true)
    }
    
    func registerCell(){
        tableSearch.register(ListSearchPlanceTableViewCell.nib(), forCellReuseIdentifier: ListSearchPlanceTableViewCell.identifier)
    }
}
