//
//  ViewController.swift
//  TransmedikSDK
//
//  Created by idham290593@gmail.com on 12/06/2021.
//  Copyright (c) 2021 idham290593@gmail.com. All rights reserved.
//

import UIKit
import TransmedikSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        
        //dev
//        Transmedik.Transmedik_Login(email: "duarcaur@gmail.com", gender: "L", device_id: "ddrsUz__QoOoNLnZ4vLdkz:APA91bGKsrxPY0IRBJ3PwXBoSLRqD-OAL9vaWGkXXv2Q9FLkMjcgwvImwD-X9pt6Ut0g2ZLfbfYirq2OGIaS-aY8ItdSmB_yn-Ab_CUNpH12T9P0EJ96fLLT2-QCKvcW6aYZmUFiYzA4", identification: "0209050203", name: "DEDI PRIYONO", nik: "7437541739567780", phone_number: "08118311001") { status, msg in
//            Transmedik.openmenu(self, present: .present)
//        }
//
        //production
        Transmedik.Transmedik_Login(email: "aloysius.john90@gmail.com", gender: "L", device_id: "ddrsUz__QoOoNLnZ4vLdkz:APA91bGKsrxPY0IRBJ3PwXBoSLRqD-OAL9vaWGkXXv2Q9FLkMjcgwvImwD-X9pt6Ut0g2ZLfbfYirq2OGIaS-aY8ItdSmB_yn-Ab_CUNpH12T9P0EJ96fLLT2-QCKvcW6aYZmUFiYzA4", identification: "04070772", name: "IVAN JOHN", nik: "3674011203900002", phone_number: "0813123123123") { status, msg in
            Transmedik.openmenu(self, present: .present)
        }
//
    }
}

