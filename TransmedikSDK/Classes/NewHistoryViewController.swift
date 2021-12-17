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
                self.user.setTitle(mdata[rowuser].full_name, for: .normal)
                getData()
            }
        }
    }
    var dataObat : ResponseDataObat?
    var dataKonsultasi : ResponseDataKonsultasi?
    var selected:Int?  // 1 untuk obat dan 2 untuk konsultasi
    var presentPage : PresentPage!
    var isconnection =  true
    var obat = Obat()
    var loading = false
    var mdata :[ModelProfile] = []
    var profile = Profile()
    var api = historiesobject()
    let userDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.userDropDown,
        ]
    }()
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
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
            closeloading(self)
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
      
        setupSpinner()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.loading(self)
        koneksi()
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
    
    func getData(){
        if CheckInternet.Connection(){
            self.getdatahistory = true
            table.backgroundView = nil
            if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
                self.api.NewGetHistories(token: token, uuid: mdata[rowuser].uuid, selected: selected, page: 1) { obat, konsultasi in
                    
                    if obat == nil && konsultasi == nil {
                        self.table.backgroundView = self.notfound
                        print("close1")
                    }
                    
                    if self.selected == 1{
                        self.dataObat = obat
                        if obat?.data?.data?.count ?? 0 == 0{
                            self.table.backgroundView = self.notfound
                            print("close2")

                        }else{

                            self.table.backgroundView = nil
                        }
                    }else{
                        self.dataKonsultasi = konsultasi
                        if  konsultasi?.data?.data?.count ?? 0 == 0 {
                            print("close2")

                            self.table.backgroundView = self.notfound
                        }else{
                            print("close3")

                            self.table.backgroundView = nil
                        }
                    }
                    
                    self.getdatahistory = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.table.reloadData()
                    }
                }
                
            }
            
        }else{
            self.table.reloadData()
            self.getdatahistory = false
            table.backgroundView = notconnection
            
        }
    }
    
    //    func getdata(){
    //        if CheckInternet.Connection(){
    //            self.loading(self)
    //                print("data baru")
    //                data.removeAll()
    //                self.table.reloadData()
    //                loading = true
    //                self.getdatahistory = true
    //                table.backgroundView = nil
    //                    if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
    //                        self.nextpage = ""
    //                        self.api.gethistories(token: token, uuid: mdata[rowuser].uuid, selected: selected) { (data,nextsp) in
    //
    //                            self.closeloading(self)
    //                            self.nextpage = nextsp
    //                            print("datanext => " + nextsp)
    //                            if nextsp == ""{
    //                                self.loading = false
    //
    //                            }else{
    //                                self.loading = true
    //
    //                            }
    //
    //                            self.getdatahistory = false
    //
    //                            if data != nil{
    //                                if data!.count > 0 {
    //                                    self.table.backgroundView = nil
    //
    //                                }else{
    //                                    self.table.backgroundView = self.notfound
    //
    //                                }
    //                                self.data = data!
    //                                self.getdatahistory = false
    //                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
    //                                    self.table.reloadData()
    //                                }
    //                            }else{
    //                                self.table.backgroundView = self.notfound
    //                                self.data.removeAll()
    //                                self.getdatahistory = false
    //                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
    //                                    self.table.reloadData()
    //                                }
    //                            }
    //
    //                        }
    //
    //
    //                    }
    //
    //
    //        }else{
    //            self.table.reloadData()
    //            self.getdatahistory = false
    //            table.backgroundView = notconnection
    //            loading = false
    //        }
    //    }
    
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
        
        if selected == 1{
            return dataObat?.data?.data?.count ?? 0
        }else{
            return dataKonsultasi?.data?.data?.count ?? 0
            
        }
        
    }
    
    func adddata(){
        if CheckInternet.Connection(){
            if selected == 1 {
                guard dataObat != nil && (dataObat!.data!.current_page! < dataObat!.data!.last_page!) else {
                    return
                }
                
            }else{
                guard dataKonsultasi != nil && (dataKonsultasi!.data!.current_page! < dataKonsultasi!.data!.last_page!) else {
                    return
                }
            }
            
            self.spinner.startAnimating()
            if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
                self.api.NewGetHistories(token: token, uuid: mdata[rowuser].uuid, selected: selected, page: dataKonsultasi!.data!.current_page! + 1) { obat, konsultasi in
                    
                  
                    
                    if self.selected == 1{
                        for index in   obat!.data!.data!{
                            self.dataObat?.data?.data?.append(index)
                        }
                        self.dataObat!.data!.current_page = obat!.data!.current_page!
                    }else{
                        for index in   konsultasi!.data!.data!{
                            self.dataKonsultasi?.data?.data?.append(index)
                        }
                        self.dataKonsultasi!.data!.current_page = konsultasi!.data!.current_page!
                    }
                    self.spinner.stopAnimating()
                    
                    self.getdatahistory = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.table.reloadData()
                    }
                }
                
            }
            
        }
    }
    
    
    //    func adddata(){
    //        if CheckInternet.Connection(){
    //            if  !getdatahistory && nextpage != ""{
    //                print("tambahdata")
    //                self.spinner.startAnimating()
    //                let rowakhir = self.data.count
    //                loading = true
    //                self.getdatahistory = true
    //                if  let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
    //                    self.api.gethiostorybyurl(token: token,url : self.nextpage ) { (data,nextsp) in
    //                        self.nextpage = ""
    //                        self.nextpage = nextsp
    //                        self.spinner.stopAnimating()
    //
    //                        if data != nil {
    //
    //                            self.table.isScrollEnabled = false
    //                            self.table.beginUpdates()
    //                            for index in data!{
    //                                print("add row data")
    //
    //                                self.data.append(index)
    //
    //                                self.table.insertRows(at: [IndexPath(row: self.data.count-1, section: 0)], with: .none)
    //
    //                            }
    //                            self.table.endUpdates()
    //                        }
    //                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
    //                            self.getdatahistory = false
    //                            if nextsp == ""{
    //                                self.loading = false
    //                                self.table.beginUpdates()
    //                                self.table.deleteRows(at: [IndexPath(row: self.data.count, section: 0)], with: .automatic)
    //                                self.table.endUpdates()
    //
    //                            }else{
    //                                self.loading = true
    //
    //                            }
    //                            self.getdatahistory = false
    //                            self.table.isScrollEnabled = true
    //
    //                            print("load")
    //
    //
    //
    //                        }
    //                    }
    //
    //
    //                }
    //
    //            }
    //        }else{
    //            self.getdatahistory = false
    //            table.backgroundView = notconnection
    //            loading = false
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selected! == 1{
            let vc = UIStoryboard(name: "Ordertracking", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "NewTrackingViewController") as? NewTrackingViewController
            vc?.id = String(dataObat!.data!.data![indexPath.row].detail_order!.order_id!)
            vc?.page = presentPage
            openVC(vc!, presentPage)
            
        }else{
            
            
            self.query = ConsultationModel.query()
            self.query = self.query.whereKey("consultation_id", equalTo: Int(self.dataKonsultasi!.data!.data![indexPath.row].detail_consultation!.consultation_id!))
            
            self.query.findObjectsInBackground(block: { (results, error) in
                if  let consultation = results as? [ConsultationModel] {
                    DispatchQueue.main.async {
                        let vc = DetailChatViewController()
                        vc.uuid_patient = self.dataKonsultasi!.data!.data![indexPath.row].detail_consultation!.patient!.uuid!
                        vc.uuid_doctor = self.dataKonsultasi!.data!.data![indexPath.row].detail_consultation!.doctor!.uuid!
                        vc.email_patient =  self.dataKonsultasi!.data!.data![indexPath.row].detail_consultation!.patient!.email!
                        vc.email_doctor =  self.dataKonsultasi!.data!.data![indexPath.row].detail_consultation!.doctor!.email!
                        let patient = ConsultationUserModel(activated_at: nil,
                                                            activation_code: nil,
                                                            balance: nil,
                                                            banned_at: nil,
                                                            banned_reason: nil,
                                                            blocked_at: nil,
                                                            blocked_reason: nil,
                                                            created_at: nil,
                                                            device_id: nil,
                                                            email: self.dataKonsultasi!.data!.data![indexPath.row].detail_consultation!.patient!.email!,
                                                            email_verified_at: self.dataKonsultasi!.data!.data![indexPath.row].detail_consultation!.patient!.email!,
                                                            full_name: self.dataKonsultasi!.data!.data![indexPath.row].detail_consultation!.patient!.full_name!,
                                                            gender: self.dataKonsultasi!.data!.data![indexPath.row].detail_consultation!.patient!.gender!,
                                                            last_activity: nil,
                                                            map_lat: nil, map_lng: nil,
                                                            parent_id: nil,
                                                            parse: nil,
                                                            phone_number: self.dataKonsultasi!.data!.data![indexPath.row].detail_consultation!.patient!.phone_number!,
                                                            profile_picture: UserDefaults.standard.string(forKey: AppSettings.profile_picture) ?? "",
                                                            ref_id: nil,
                                                            ref_type: nil,
                                                            registered_at: nil,
                                                            status: nil,
                                                            updated_at: nil, uuid: self.dataKonsultasi!.data!.data![indexPath.row].detail_consultation!.patient!.uuid!)
                        
                        let doctor = ConsultationUserModel(activated_at: nil,
                                                           activation_code: nil,
                                                           balance: nil,
                                                           banned_at: nil,
                                                           banned_reason: nil,
                                                           blocked_at: nil,
                                                           blocked_reason: nil,
                                                           created_at: nil,
                                                           device_id: nil,
                                                           email: self.dataKonsultasi!.data!.data![indexPath.row].detail_consultation!.doctor!.email!,
                                                           email_verified_at: self.dataKonsultasi!.data!.data![indexPath.row].detail_consultation!.doctor!.email!,
                                                           full_name: self.dataKonsultasi!.data!.data![indexPath.row].detail_consultation!.doctor!.full_name!,
                                                           gender: self.dataKonsultasi!.data!.data![indexPath.row].detail_consultation!.doctor!.gender!,
                                                           last_activity: nil,
                                                           map_lat: nil, map_lng: nil,
                                                           parent_id: nil,
                                                           parse: nil,
                                                           phone_number: self.dataKonsultasi!.data!.data![indexPath.row].detail_consultation!.doctor!.phone_number!,
                                                           profile_picture:self.dataKonsultasi!.data!.data![indexPath.row].detail_consultation!.doctor!.profile_picture!,
                                                           ref_id: nil,
                                                           ref_type: nil,
                                                           registered_at: nil,
                                                           status: nil,
                                                           updated_at: nil, uuid: self.dataKonsultasi!.data!.data![indexPath.row].detail_consultation!.doctor!.uuid!)
                        
                        
                        
                        let cconsul = ConsultationPostModel(consultation_id: Int(self.dataKonsultasi!.data!.data![indexPath.row].detail_consultation!.consultation_id!), doctor: doctor, patient: patient)
                        
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
        if selected! == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "konsultasi", for: indexPath) as! historiescellkonsulTableViewCell
            cell.row = indexPath.row
            cell.delegate = self
            cell.historyTwo(data: dataKonsultasi!.data!.data![indexPath.row])
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "konsultasi", for: indexPath) as! historiescellkonsulTableViewCell
            cell.row = indexPath.row
            cell.delegate = self
            cell.historyOne(data: dataObat!.data!.data![indexPath.row])
            
            return cell
        }
        
        
        
    }
    
    
    
}


extension NewHistoryViewController: historiescellkonsulTableViewCelldelegate,ratingViewControllerdelegate{
    func kembalirating() {
        getData()
    }
    
    func chatulang(row: Int) {
        
        if dataKonsultasi!.data!.data![row].detail_consultation!.clinic!.medical_form!{
            let apifacility = FormObject()
            if let token = UserDefaults.standard.string(forKey: AppSettings.Tokentransmedik) {
                var list : [listformmodel] = []
                var valueform : [valuesonform] = []
                
                apifacility.getform(token: token, id: String(dataKonsultasi!.data!.data![row].detail_consultation!.clinic!.id!), spesialist: dataKonsultasi!.data!.data![row].detail_consultation!.doctor!.specialist_slug!) { data, msg in
                    for index in data {
                        valueform.append(valuesonform(id: index.id, question: index.question, jawaban: "", required: index.required))
                    }
                    list = data
                    let vc = UIStoryboard(name: "Profiledokter", bundle: AppSettings.bundleframeworks()).instantiateViewController(withIdentifier: "NewProfileDokterVC") as? NewProfileDokterVC
                   // vc?.data = ?? //musti di isi data dokter
                    vc?.header = self.dataKonsultasi!.data!.data![row].detail_consultation!.doctor!.specialist!
                    vc?.uuid = self.dataKonsultasi!.data!.data![row].detail_consultation!.doctor!.uuid!
                    vc?.isform =  false
                    vc?.id = String(self.dataKonsultasi!.data!.data![row].detail_consultation!.clinic!.name!)
                    vc?.facilityid = String(self.dataKonsultasi!.data!.data![row].detail_consultation!.clinic!.id!)
                    vc?.presentPage = self.presentPage
                    self.openVC(vc!, self.presentPage)
                }
                
            }
        }else{
            let vc = UIStoryboard(name: "Profiledokter", bundle: AppSettings.bundleframeworks()).instantiateViewController(withIdentifier: "NewProfileDokterVC") as? NewProfileDokterVC
           // vc?.data = ?? //musti di isi data dokter
            vc?.header = self.dataKonsultasi!.data!.data![row].detail_consultation!.doctor!.specialist!
            vc?.uuid = self.dataKonsultasi!.data!.data![row].detail_consultation!.doctor!.uuid!
            vc?.isform =  false
            vc?.id = String(self.dataKonsultasi!.data!.data![row].detail_consultation!.clinic!.name!)
            vc?.facilityid = String(self.dataKonsultasi!.data!.data![row].detail_consultation!.clinic!.id!)
            vc?.presentPage = self.presentPage
            self.openVC(vc!, self.presentPage)
        }
    }
    
    func nilai(row: Int) {
        let vc = UIStoryboard(name: "rating", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "ratingViewController") as? ratingViewController
        vc?.id = String(dataKonsultasi!.data!.data![row].detail_consultation!.consultation_id!)
        vc?.delegate = self
        self.present(vc!, animated: false, completion: nil)
    }
    
    
    
}

extension NewHistoryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            adddata()
        }
        
    }
}



