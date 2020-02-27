//
//  CarCell.swift
//  bat
//
//  Created by Mike Peterson on 7/27/19.
//  Copyright © 2019 foobax. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class CarCell: UITableViewCell {
    
    @IBOutlet var carImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!

    override func awakeFromNib() {
        
        contentView.backgroundColor = .clear
        carImageView.backgroundColor = .clear
        titleLabel.backgroundColor = .clear
        priceLabel.backgroundColor = .clear
        dateLabel.backgroundColor = .clear
    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }

    override func didMoveToSuperview() {
        self.layoutIfNeeded()
    }

    func configureForProduct(_ car: Car) {
        
        if let imageUrl = URL(string: car.image) {
            carImageView.af_setImage(withURL: imageUrl)
        } else {
            carImageView.image = nil
        }
        
        titleLabel.text = car.title
        priceLabel.text =  CURRENCY_FORMATTER.string(from: NSNumber(value: car.amount))
        
        dateLabel.text = DATE__MMddyyyy_FORMATTER.string(from: Date(timeIntervalSince1970: car.timestamp))
        dateLabel.textColor = .lightGray
        
        priceLabel.textColor = car.reserveMet ? UIColor(red: 231/255.0, green: 76/255.0, blue: 60/255.0, alpha: 1) : UIColor(red: 39/255.0, green: 174/255.0, blue: 96/255.0, alpha: 1)
    }
}


//bat.Car(amount: 26000,
//        image: "https://bringatrailer.com/wp-content/uploads/2019/05/2008_bmw_alpina_b7_15609555290c05662a2008_bmw_alpina_b7_1560955508a67856724221e9dIMG_8663-1-155x105.jpg",
//        timestamp: 1561662000,
//        title: "No Reserve: 2008 BMW Alpina B7",
//        titlesub: "Sold for $26,000 on 6/27/19",
//        url: "https://bringatrailer.com/listing/2008-bmw-alpina-b7-4/")]
