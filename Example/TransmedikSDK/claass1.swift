//
//  claass1.swift
//  TransmedikSDK_Example
//
//  Created by Idham Kurniawan on 28/01/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class kelas1 : abstracViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func masuk (){
        print(dou)
//        let gg : UIViewController = ViewController
        let vc = UIStoryboard(name: "", bundle: nil).instantiateViewController(withIdentifier: "dasd") as? ViewController
        
    }
   
}
