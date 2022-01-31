//
//  ResepViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 06/09/21.
//

import UIKit
import SwiftyJSON
import Alamofire
import CDAlertView
import CoreLocation



//
class ResepViewController: UIViewController,CLLocationManagerDelegate {
    
    
    @IBOutlet weak var navi: UIView!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var back: UIView!
    
    
    @IBOutlet weak var stuckAlamat: UIStackView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var doctorPhoto: UIImageView!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var nomor: UILabel!
    
    @IBOutlet weak var pasienPhoto: UIImageView!
    @IBOutlet weak var pasienName: UILabel!
    @IBOutlet weak var pasienAge: UILabel!
    
    @IBOutlet weak var tables: UITableView!
    
    @IBOutlet weak var tinggiTable: NSLayoutConstraint!
    @IBOutlet weak var tglExp: UILabel!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var viewAlamat: UIView!
    @IBOutlet weak var alamat: UILabel!
    @IBOutlet weak var note: UILabel!
    
    
    @IBOutlet weak var beli: UIView!
    
    let locationManager = CLLocationManager()
    var consultation: ConsultationPostModel?
    var json: JSON?
    var api = resepdigitalobject()
//    var resep = [Resepobat]()
    var prescription_id = ""
    var data : Resepdigital?
    var location : NameMyLocation?

   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        beli.isUserInteractionEnabled = false
//        stuckAlamat.isHidden.toggle()
        self.view.layoutIfNeeded()
        self.view.backgroundColor = Colors.backgroundmaster
        pasienPhoto.layer.cornerRadius = 25
        doctorPhoto.layer.cornerRadius = 30
        registerTableView()
        tables.dataSource = self
        tables.delegate = self
        note.isEnabled  = false
        navi.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        viewAlamat.layer.cornerRadius = 10
        viewAlamat.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getalamat)))
        viewAlamat.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        view1.layer.cornerRadius = 10
        view1.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        
        view2.layer.cornerRadius = 10
        view2.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        
        
        view3.layer.cornerRadius = 10
//        view3.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
//
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        tinggiTable.constant = tables.contentSize.height
        beli.layer.cornerRadius = 10
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        beli.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buy)))
        if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
            api.getresep(token: token, id: String(consultation!.consultation_id!)) { data in
                
                do {
                    let decoder = JSONDecoder()
                    let respon = try decoder.decode(responresep.self, from: data!)
                    self.data = respon.data
                    self.prescription_id = String(respon.data!.recipes![0].prescription_id!)
                    self.doctorName.text = respon.data?.doctor?.doctor_name ?? ""
                    self.nomor.text = respon.data?.doctor?.number ?? ""
                    let url = URL(string: respon.data?.doctor?.image ?? "")
                    self.doctorPhoto.kf.setImage(with: url)
                    let urls = URL(string: (respon.data?.patient!.image)!)
                    self.pasienPhoto.kf.setImage(with: urls)
                    self.pasienName.text = respon.data!.patient!.patient_name
                    self.pasienAge.text = respon.data!.patient!.age
                    self.tglExp.text = respon.data!.expires
                    self.tables.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.tables.layoutIfNeeded()
                        self.tinggiTable.constant = self.tables.contentSize.height
                    }
                    
                    
                    
                    
                    
                } catch {
                    // print("eror")
                }
            }
            
        }
        
    }
    
    @objc func getalamat(){
//        let vc = UIStoryboard(name: "Alamat", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "AlamatVC") as? AlamatVC
//        vc?.delegate = self
//        
//        present(vc!, animated: true, completion: nil)
    }
    
    private func registerTableView() {
        tables.register(ResepObatTableViewCell.nib(), forCellReuseIdentifier: ResepObatTableViewCell.identifier)
    }
    
    @objc func kembali(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func buy(){
        let vc = UIStoryboard(name: "Orderobat", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "OrderobatViewController") as? OrderobatViewController
        vc?.id = String(self.consultation!.consultation_id!)
        vc?.location = self.location
        var param = [Parameters]()
        for index in  self.data!.recipes!{
            param.append([  "medicine": index.slug!,
                            "medicine_code_partner": index.medicine_code_partner!,
                            "prescription_id": index.prescription_id!,
                            "qty": index.qty!
            ])
        }
        vc?.order = param
        
        vc?.prescription_id = self.prescription_id
        self.present(vc!, animated: true, completion: nil)
        
   
        
    }
    
    
    
    
    
}

extension ResepViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // print("retun =>> \(data?.recipes?.count ?? 0)")
        return data?.recipes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResepObatTableViewCell.identifier, for: indexPath) as! ResepObatTableViewCell
        cell.config(data: data!.recipes![indexPath.row])
        
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        // print("willDisplay")
    //
    //
    //    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // print("scrollViewDidScroll")
        tables.layoutIfNeeded()
        self.tinggiTable.constant = tables.contentSize.height
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // print("willDisplay")
        tableView.layoutIfNeeded()
        self.tinggiTable.constant = tableView.contentSize.height
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView(tableView: tableView, willDisplayMyCell: cell as! ResepObatTableViewCell, forRowAtIndexPath: indexPath)
    }
    
    private func tableView(tableView: UITableView, willDisplayMyCell myCell: ResepObatTableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // print("willDisplay2")
        
        tableView.layoutIfNeeded()
        self.tinggiTable.constant = tableView.contentSize.height    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        // print("estimatedHeightForRowAt")
        
        //        return  UITableViewAutomaticDimension
    }
    
}


extension ResepViewController : SetMapingViewControllerDelegate{
    func setLocation(long: Double, lat: Double, alamat: String, note: String) {
        location = NameMyLocation(location: CLLocationCoordinate2D(latitude: lat, longitude: long), address: alamat, note: note)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations[0]
//
//        let tmplocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let loc = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
////         print("get my location")
////         print(tmplocation)
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(loc) { (locstring, err) in
//            if let _ = err {
//                return // print("error cuy")
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
////                 print(addressString)
//                self.alamat.text = addressString
//                if self.location == nil {
//                    self.location = NameMyLocation(location: tmplocation, address: addressString, note: "")
//                }
//
//                //                // print(addressString)
//            }
//
//
//        }
//
        locationManager.stopUpdatingLocation()
        
    }
    
    
}


extension ResepViewController {
//    func getLocation(location: CLLocationCoordinate2D, address: String, note: String) {
//
//        self.location = NameMyLocation(location: location, address: address, note: note)
//        alamat.text = address
//        self.note.text = note == "" ? "Catatan anda" : note
//    }
    
    
//    func getDetailLocation(){
//        guard location != nil else {
//            return
//        }
//        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(self.location!.location.latitude),\(self.location!.location.longitude )&key=AIzaSyDYhPXYjgCmT7ZO8jZigFm8iPXY_e16C8M"
//
//        Alamofire.request(url, method: .get, encoding: JSONEncoding.default)
//            .responseJSON { respon in
//                                 print(respon)
//
//                switch respon.result {
//                case let .success(value):
//                    let json = JSON(value)
//                    do{
//                        let result = try JSONDecoder().decode(ResponsePlancesMod.self, from: json.rawData())
//
//                        self.alamat.text = result.results![0].formatted_address ?? ""
//                        self.note.text = ""
//
//
//                    }catch{
//                        print("error Model")
//                    }
//
//                //                    print(value)
//                case let .failure(error):
//
//                    break
//                }
//
//
//            }
//    }
    
}
