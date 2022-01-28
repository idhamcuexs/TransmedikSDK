//
//  abstracViewController.swift
//  TransmedikSDK_Example
//
//  Created by Idham Kurniawan on 28/01/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class abstracViewController: UIViewController ,list{
    
    var classmap : UIViewController?
    
    var dou = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func data(view: UIViewController) {
        classmap = view
    }
    
   
}
