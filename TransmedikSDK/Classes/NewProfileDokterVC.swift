//
//  NewProfileDokterVC.swift
//  transmedik
//
//  Created by Idham Kurniawan on 18/11/21.
//

import UIKit
import Kingfisher

class NewProfileDokterVC: UIViewController {

    
    @IBOutlet weak var navi: UIView!
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var nameDokter: UILabel!
    @IBOutlet weak var specialist: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var pengalaman: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var alumni: UILabel!
    @IBOutlet weak var praktek: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var viewInformation: UIView!
    @IBOutlet weak var nostr: UILabel!
    

    
    var dataDokter : NewDetailDokter!
    var uuid = ""
    var profil = Doctors()
    var presentPage : PresentPage!
    var isform = false
    var list : [listformmodel] = []
    var header = ""
    var facilityid = ""{
        didSet{
            print("facilityid ==>> \(facilityid)")
        }
    }
    var id = ""{
        didSet{
            print("id ==>> \(id)")
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        layout()
        getdatadokter()
        self.view.layoutIfNeeded()
    }
    
    
    func getdatadokter(){
        if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik){
            let param : [String : Any ] = ["specialist_slug" : self.specialist,
                                           "uuid_doctor" : self.uuid]
            self.profil.NewGetDokter(token: token, id: self.uuid) { data in
                guard data != nil else {return}
                if data!.code == 200 {
                    self.dataDokter = data?.data!
                    self.setData()
                }else{
                    Toast.show(message: data!.messages!, controller: self)
                }
                
            }
//            self.profil.getdokter(token: token, id: self.uuid) { (data) in
//                if data != nil {
//                    let edu = data!.educations.map{ $0.education}
//                    self.alumni.text =  edu.joined(separator: ",").count == 0 ? "-" : edu.joined(separator: ",")
//                    self.praktek.text = data!.facilitiesstring
//                    self.nostr.text = data!.no_str
//
//                }
//
//
//            }
        }
    }
    
    func setData(){
        if dataDokter!.profile_picture ?? "" != "" {
            let url = URL(string: dataDokter!.profile_picture! )
            photo.kf.setImage(with: url)

        }
        let edu = dataDokter!.educations!.map{ $0.education!}
        self.alumni.text =  edu.joined(separator: ",").count == 0 ? "-" : edu.joined(separator: ",")
        let fasilitasArray = dataDokter!.facilities!.map{ $0.name!}
        self.praktek.text =  fasilitasArray.joined(separator: ",").count == 0 ? "-" : edu.joined(separator: ",")
        self.nostr.text = dataDokter!.no_str!
        nameDokter.text = dataDokter!.full_name
        specialist.text = dataDokter.specialist
        price.text = "Rp \(dataDokter!.rates!.formattedWithSeparator)"
        rate.text = String(dataDokter!.rating!)
        pengalaman.text = dataDokter.experience!
        
           if dataDokter!.status_docter! == "Online"{
               chatButton.backgroundColor = Colors.buttonActive
               viewStatus.backgroundColor = Colors.buttonActive
               status.text = "Available"
           }else{
               chatButton.backgroundColor = Colors.buttonnonActive
               viewStatus.backgroundColor = Colors.buttonnonActive
               status.text = "Not Available"


           }
        
    }
    func layout(){
        navi.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
        viewDetail.backgroundColor = Colors.backgroundmaster
        self.view.backgroundColor = Colors.backgroundmaster
        viewStatus.layer.cornerRadius = 6
        chatButton.layer.cornerRadius = 10
        viewInformation.layer.cornerRadius = 10
        viewInformation.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
    }
    
    
    
    @IBAction func chatOnClick(_ sender: Any) {
        guard dataDokter!.status_docter! == "Online" else { return }
        let vc = UIStoryboard(name: "Chat", bundle: AppSettings.bundleframeworks()).instantiateViewController(withIdentifier: "NewCheckConsulVC") as? NewCheckConsulVC
        vc?.header = header
        vc?.list = list
        vc?.isform = isform
//        vc?.presentPage = self.presentPage
        vc?.facilityid = facilityid
        vc?.id = id
        vc?.uuid = dataDokter!.uuid!
        present(vc!, animated: true, completion: nil)
//        openVC(vc!, presentPage)

    }
    
    @IBAction func backOnClick(_ sender: Any) {
       keluar(view: presentPage)
    }
    
}




