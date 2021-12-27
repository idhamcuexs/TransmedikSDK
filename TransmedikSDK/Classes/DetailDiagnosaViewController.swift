//
//  DetailDiagnosaViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 21/12/21.
//

import UIKit
import Kingfisher
import SwiftyJSON



class DetailCatatanDiagnosaVC: UIViewController {
    
    @IBOutlet weak var navi: UIView!
    
    @IBOutlet weak var viewMasterOne: UIView!
    @IBOutlet weak var Photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var waktu: UILabel!
    @IBOutlet weak var nk: UILabel!
    @IBOutlet weak var nomorDokter: UILabel!
    
    @IBOutlet weak var viewMasterTwo: UIView!
    @IBOutlet weak var tableSymp: UILabel!
    
    @IBOutlet weak var viewMasterTree: UIView!
    @IBOutlet weak var tablePD: UILabel!
    
    @IBOutlet weak var viewMasterFour: UIView!
    @IBOutlet weak var tableICD: UILabel!
    
    @IBOutlet weak var viewMasterFive: UIView!
    @IBOutlet weak var tableAdvice: UILabel!
    
    
    var presentPage : PresentPage!
    var consultation: ConsultationPostModel?
    var date = ""
    var dokterString = ""
    var spesialis = ""
    var nomorString = ""
    var phtoString = ""
    
    var json: JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        layout()
        initializeDatas()
        
    }
    
    func initializeDatas() {
        let spa = json!["spa"]
        var symptoms = spa["symptoms"].string
        symptoms = symptoms?.replacingOccurrences(of: "|", with: "\r\n")
        var possible_diagnosis = spa["possible_diagnosis"].string
        possible_diagnosis = possible_diagnosis?.replacingOccurrences(of: "|", with: "\r\n")
        var advice = spa["advice"].string
        advice = advice?.replacingOccurrences(of: "|", with: "\r\n")
        //        spa["icd"].arrayspa["icd"]
//        var icd = spa["icd"].string
//        icd = advice?.replacingOccurrences(of: "|", with: "\r\n")
        waktu.text = date
        nk.text = spesialis
        nomorDokter.text = nomorString
        name.text = dokterString
        
        
        if phtoString != ""{
            let url = URL(string: phtoString)
            Photo.kf.setImage(with: url)
        }
        Photo.layer.cornerRadius = 25
     
        tableSymp.text = symptoms
        tablePD.text = possible_diagnosis
//        tableICD.text = icd
      
        if  spa["icd"].array != nil{
            var icdString = ""
            spa["icd"].array?.forEach({ (data) in
                if icdString == ""{
                    icdString =  data["name"].stringValue
                }else{
                    icdString += "\r\n " + data["name"].stringValue
                }
            })
            tableICD.text = icdString
        }else{
            self.viewMasterFour.isHidden.toggle()
        }

    }
    
    
    
    func layout(){
        viewMasterOne.layer.cornerRadius = 10
        viewMasterTwo.layer.cornerRadius = 10
        viewMasterTree.layer.cornerRadius = 10
        viewMasterFour.layer.cornerRadius = 10
        viewMasterFive.layer.cornerRadius = 10
        
        self.view.backgroundColor = Colors.backgroundmaster
        
        navi.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        
        viewMasterOne.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        viewMasterTwo.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        viewMasterTree.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        viewMasterFour.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        viewMasterFive.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        
    }
    
    
    @IBAction func backOnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
