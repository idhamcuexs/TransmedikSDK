//
//  ListSearchPlanceTableViewCell.swift
//  TransmedikSDK_Example
//
//  Created by Idham Kurniawan on 25/02/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class ListSearchPlanceTableViewCell: UITableViewCell {

    static let identifier = "ListSearchPlanceTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "ListSearchPlanceTableViewCell", bundle: AppSettings.bundleframeworks())
    }
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var views: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        views.layer.cornerRadius = 6
        views.dropShadow(shadowColor: UIColor.lightGray, fillColor: UIColor.white, opacity: 0.5, offset: CGSize(width: 2, height: 2), radius: 4)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
