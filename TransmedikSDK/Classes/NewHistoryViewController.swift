//
//  NewHistoryViewController.swift
//  transmedik
//
//  Created by Idham Kurniawan on 10/12/21.
//sd

import UIKit
import DropDown
import Parse



class NewHistoryViewController: UIViewController {

    @IBOutlet var notfound: UIView!
    @IBOutlet var notconnection: UIView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var back: UIView!
    @IBOutlet weak var viewuser: UIView!
    @IBOutlet weak var navi: UIView!
    var getdatahistory = true
    @IBOutlet weak var user: UIButton!
    var listname:[String] = []
    var query: PFQuery<PFObject>!
    var rowuser = 0{
        didSet{
            if mdata.count > 0{
                self.uuid = mdata[rowuser].uuid
                self.user.setTitle(mdata[rowuser].full_name, for: .normal)
                getdata()
            }
        }
    }
    var selected:Int?  // 1 untuk obat dan 2 untuk konsultasi
    var presentPage : PresentPage!
    var isconnection =  true
    var token = ""
    var data : [ModelHistories] = []
    var obat = Obat()
    var loading = false
    var mdata :[ModelProfile] = []
    var profile = Profile()
    var uuid = ""
    var api = historiesobject()
    var nextpage = ""
    let userDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.userDropDown,
        ]
    }()
    var spinner = UIActivityIndicatorView(style: .gray)

    var success = false{
        didSet{
            set()
        }
    }
    var loadingint = 0{
        didSet{
            set()
        }
    }
    
    
    func set(){
        if success && loadingint == 2 {
            setuser()
            if mdata.count > 0{
                rowuser = 0
            }
           
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Colors.backgroundmaster
        self.view.layoutIfNeeded()
        shadownavigation.shadownav(view: navi)
        isconnection = CheckInternet.Connection()
        viewuser.layer.cornerRadius = user.frame.height / 2
        viewuser.layer.shadowColor = UIColor.black.cgColor
        viewuser.layer.shadowOffset = CGSize.zero
        viewuser.layer.shadowRadius = 2
        viewuser.layer.shadowOpacity = 0.2
        back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kembali)))
        self.tabBarController?.tabBar.isHidden = true
        koneksi()
        setupSpinner()
        

    }
    
    func getdata(status: Bool) {
        getdatahistory = status
    }
    
    @IBAction func showuser(_ sender: Any) {
        if !getdatahistory{
            userDropDown.show()
        }
    }
    
    func setupSpinner() {
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.table.bounds.width, height: CGFloat(44))
        self.table.tableFooterView = spinner
    }
    
    func getdata(){
        if CheckInternet.Connection(){
            self.loading(self)
                print("data baru")
                data.removeAll()
                self.table.reloadData()
                loading = true
                self.getdatahistory = true
                table.backgroundView = nil
                    if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
                        self.nextpage = ""
                        self.api.gethistories(token: token, uuid: self.uuid, selected: selected) { (data,nextsp) in
                            
                            self.closeloading(self)
                            self.nextpage = nextsp
                            print("datanext => " + nextsp)
                            if nextsp == ""{
                                self.loading = false
                                
                            }else{
                                self.loading = true
                                
                            }
                            
                            self.getdatahistory = false
                            
                            if data != nil{
                                if data!.count > 0 {
                                    self.table.backgroundView = nil
                                    
                                }else{
                                    self.table.backgroundView = self.notfound
                                    
                                }
                                self.data = data!
                                self.getdatahistory = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    self.table.reloadData()
                                }
                            }else{
                                self.table.backgroundView = self.notfound
                                self.data.removeAll()
                                self.getdatahistory = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    self.table.reloadData()
                                }
                            }
                            
                        }
                        
                        
                    }
                
            
        }else{
            self.table.reloadData()
            self.getdatahistory = false
            table.backgroundView = notconnection
            loading = false
        }
    }
    
    func setuser(){
        userDropDown.anchorView = user
        userDropDown.bottomOffset = CGPoint(x: 0, y: user.bounds.height)
        userDropDown.dataSource = listname
        userDropDown.selectionAction = { [weak self] (index, item) in
            self?.rowuser = index
//            self?.user.setTitle(item, for: .normal)
        }
    }
    
    
    @objc func kembali(){
        keluar(view: presentPage)
    }
    
    
    func koneksi(){
        if CheckInternet.Connection(){
            mdata.removeAll()
            listname.removeAll()
            success = false
            loadingint = 0
                if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
                    
                    self.profile.getprofile(token: token) { (data,msg) in
                        if msg.contains("Unauthenticated"){
                            UserDefaults.standard.set(true, forKey: "Unauthenticated")
                            
                        }
                        print("complited profile")
                        if data != nil {
                            print("my name = >\(data!.full_name)")
                            self.listname.insert(data!.full_name, at: 0)
                            self.mdata.insert(data!, at: 0)
                            self.success = true
                        }else{
                            self.success = false
                            
                        }
                        self.loadingint += 1
                    }
                    
                    self.profile.getkeluarga(token: token) { (keluarga,status,msg) in
                        if msg.contains("Unauthenticated"){
                            UserDefaults.standard.set(true, forKey: "Unauthenticated")
                        }
//                        self.loadingint += 1
                        print("complited keluarga")
                        print("status ==>> \(status)")
                        if status{
                            if keluarga != nil {
                                for tempkeluarga in keluarga!{
                                    self.listname.append(tempkeluarga.full_name)
                                    
                                    self.mdata.append(tempkeluarga)
                                }
                                self.success = true
                                
                            }else{
                                self.success = true

                            }
                        }else{
                            self.success = false

                        }
                        self.loadingint += 1
                      
                    }
                    
                    
                }
            
            
        }else{
            connectionfailed()
        }
        
    }
    func connectionfailed() {
        table.backgroundView = notconnection
        loading = false
    }
  
}



extension NewHistoryViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //    historiescellobatTableViewCell
        
        if loading {
            print("loading true")
            return data.count == 0 ? 1 : data.count + 1
        }else{
            print("loading false")
            return data.count
        }
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("row => \(indexPath.row) =>>>\(self.data.count) ")
//        print( self.loading)
//        print(self.nextpage)
//        if self.loading && self.nextpage != "" &&  self.data.count > 0 {
//            let rows = self.data.count - 2
//            if indexPath.row == rows  {
//                self.adddata()
//            }
//
//        }
//    }
    
    
    func adddata(){
        if CheckInternet.Connection(){
            if  !getdatahistory && nextpage != ""{
                print("tambahdata")
                self.spinner.startAnimating()
                let rowakhir = self.data.count
                loading = true
                self.getdatahistory = true
                if  let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
                        self.api.gethiostorybyurl(token: token,url : self.nextpage ) { (data,nextsp) in
                            self.nextpage = ""
                            self.nextpage = nextsp
                            self.spinner.stopAnimating()
                            
                            if data != nil {
                              
                                self.table.isScrollEnabled = false
                                self.table.beginUpdates()
                                for index in data!{
                                    print("add row data")
                                    
                                    self.data.append(index)
                                    
                                    self.table.insertRows(at: [IndexPath(row: self.data.count-1, section: 0)], with: .none)
                                    
                                }
                                self.table.endUpdates()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                self.getdatahistory = false
                                if nextsp == ""{
                                    self.loading = false
                                    self.table.beginUpdates()
                                    self.table.deleteRows(at: [IndexPath(row: self.data.count, section: 0)], with: .automatic)
                                    self.table.endUpdates()
                                    
                                }else{
                                    self.loading = true
                                    
                                }
                                self.getdatahistory = false
                                self.table.isScrollEnabled = true
                                
                                print("load")
                                
                                
                                
                            }
                        }
                        
                        
                    }
                
            }
        }else{
            self.getdatahistory = false
            table.backgroundView = notconnection
            loading = false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if data[indexPath.row].type_history == "1"{
            let vc = UIStoryboard(name: "Ordertracking", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "NewTrackingViewController") as? NewTrackingViewController
            vc?.id = String(data[indexPath.row].detail_medicine[0].order_id)
            vc?.page = presentPage
            openVC(vc!, presentPage)
              
        }else{
            print("masuk")
            print(data[indexPath.row].detail_consultation!.consultation_id)
            self.query = ConsultationModel.query()
            self.query = self.query.whereKey("consultation_id", equalTo: Int(data[indexPath.row].detail_consultation!.consultation_id))
            
            self.query.findObjectsInBackground(block: { (results, error) in
                if  let consultation = results as? [ConsultationModel] {
                    DispatchQueue.main.async {
                        let vc = DetailChatViewController()
                        
                        vc.uuid_patient = self.data[indexPath.row].detail_consultation!.patient.uuid
                        vc.uuid_doctor = self.data[indexPath.row].detail_consultation!.doctor.uuid
                        vc.email_patient =  self.data[indexPath.row].detail_consultation!.patient.email
                        vc.email_doctor =  self.data[indexPath.row].detail_consultation!.doctor.email
                        let patient = ConsultationUserModel(activated_at: nil,
                                                           activation_code: nil,
                                                           balance: nil,
                                                           banned_at: nil,
                                                           banned_reason: nil,
                                                           blocked_at: nil,
                                                           blocked_reason: nil,
                                                           created_at: nil,
                                                           device_id: nil,
                                                           email: self.data[indexPath.row].detail_consultation!.patient.email,
                                                           email_verified_at: self.data[indexPath.row].detail_consultation!.patient.email,
                                                           full_name: self.data[indexPath.row].detail_consultation!.patient.full_name,
                                                           gender: self.data[indexPath.row].detail_consultation!.patient.gender,
                                                           last_activity: nil,
                                                           map_lat: nil, map_lng: nil,
                                                           parent_id: nil,
                                                           parse: nil,
                                                           phone_number: self.data[indexPath.row].detail_consultation!.patient.phone_number,
                                                           profile_picture: self.data[indexPath.row].detail_consultation!.patient.image,
                                                           ref_id: nil,
                                                           ref_type: nil,
                                                           registered_at: nil,
                                                           status: nil,
                                                           updated_at: nil, uuid: self.data[indexPath.row].detail_consultation!.patient.uuid)
                        
                        let doctor = ConsultationUserModel(activated_at: nil,
                                                           activation_code: nil,
                                                           balance: nil,
                                                           banned_at: nil,
                                                           banned_reason: nil,
                                                           blocked_at: nil,
                                                           blocked_reason: nil,
                                                           created_at: nil,
                                                           device_id: nil,
                                                           email: self.data[indexPath.row].detail_consultation!.doctor.email,
                                                           email_verified_at: self.data[indexPath.row].detail_consultation!.doctor.email,
                                                           full_name: self.data[indexPath.row].detail_consultation!.doctor.full_name,
                                                           gender: self.data[indexPath.row].detail_consultation!.doctor.gender,
                                                           last_activity: nil,
                                                           map_lat: nil, map_lng: nil,
                                                           parent_id: nil,
                                                           parse: nil,
                                                           phone_number: self.data[indexPath.row].detail_consultation!.doctor.phone_number,
                                                           profile_picture: self.data[indexPath.row].detail_consultation!.doctor.profile_picture,
                                                           ref_id: nil,
                                                           ref_type: nil,
                                                           registered_at: nil,
                                                           status: nil,
                                                           updated_at: nil, uuid: self.data[indexPath.row].detail_consultation!.doctor.uuid)
                        
                        
                        
                        let cconsul = ConsultationPostModel(consultation_id: Int(self.data[indexPath.row].detail_consultation!.consultation_id), doctor: doctor, patient: patient)
                        
                        vc.currentConsultation = cconsul
                        vc.currentDoctor = consultation[0].doctor
                        vc.currentUser = consultation[0].patient
                        
                        
                        let nav = UINavigationController(navigationBarClass: UICustomNavigationBar.self, toolbarClass: nil)
                        nav.modalPresentationStyle = .fullScreen
                        nav.pushViewController(vc, animated: false)
                        self.present(nav, animated: true, completion: nil)
                        
                    }
                
                }else{
                    Toast.show(message: "Tidak dapat terhubung pada server .", controller: self)
                }
                   
            })
        }
    }
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if loading{
            if data.count == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "loading", for: indexPath)
                return cell
            }else{
                if indexPath.row < data.count{
                    if data[indexPath.row].type_history == "2" {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "konsultasi", for: indexPath) as! historiescellkonsulTableViewCell
                        cell.row = indexPath.row
                        cell.delegate = self
                        cell.historyTwo(data: data[indexPath.row])

                        return cell
                    }else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "konsultasi", for: indexPath) as! historiescellkonsulTableViewCell
                        cell.row = indexPath.row
                        cell.delegate = self
                        cell.historyOne(data: data[indexPath.row])

                        return cell
                    }
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "loading", for: indexPath)
                    return cell
                }
            }
            
        }else{
            print("pathrow")
            if data[indexPath.row].type_history == "2" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "konsultasi", for: indexPath) as! historiescellkonsulTableViewCell
                cell.row = indexPath.row
                cell.delegate = self
                cell.historyTwo(data: data[indexPath.row])

                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "konsultasi", for: indexPath) as! historiescellkonsulTableViewCell
                cell.row = indexPath.row
                cell.delegate = self
                cell.historyOne(data: data[indexPath.row])

                return cell
    
            }
        }
        
        
        
    }
    
    
    
}


extension NewHistoryViewController: historiescellkonsulTableViewCelldelegate,ratingViewControllerdelegate{
    func kembalirating() {
        getdata()
    }
    
    func chatulang(row: Int) {
        let vc = UIStoryboard(name: "Profiledokter", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "profiledoktermasterViewController") as? profiledoktermasterViewController
        vc?.data = data[row].detail_consultation!.doctor
        vc?.uuid = data[row].detail_consultation!.doctor.uuid
        present(vc!, animated: true, completion: nil)
    }
    
    func nilai(row: Int) {
        let vc = UIStoryboard(name: "rating", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "ratingViewController") as? ratingViewController
          vc?.id = data[row].detail_consultation!.consultation_id
          vc?.delegate = self
          self.present(vc!, animated: false, completion: nil)
    }
    
    
  
}

extension NewHistoryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if data.count != 0  {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            
            if offsetY > contentHeight - scrollView.frame.size.height {
                print("new data")
                adddata()
            }
        }
    }
}



