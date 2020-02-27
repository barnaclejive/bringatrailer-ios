//
//  Car.swift
//  bat
//
//  Created by Mike Peterson on 7/27/19.
//  Copyright © 2019 foobax. All rights reserved.
//

import Foundation

struct Car {
    
    var amount: Int
    var image: String
    var timestamp: Double
    var title: String
    var titlesub: String
    var url: String
    var reserveMet: Bool
    
    init(data: AnyObject) {
        
        amount = data["amount"] as! Int
        image = data["image"] as! String
        timestamp = data["timestamp"] as! Double
        title = data["title"] as! String
        titlesub = data["titlesub"] as! String
        url = data["url"] as! String
        
        reserveMet = titlesub.lowercased().starts(with: "sold")
    }
}


//amount = 26000;
//image = "https://bringatrailer.com/wp-content/uploads/2019/05/2008_bmw_alpina_b7_15609555290c05662a2008_bmw_alpina_b7_1560955508a67856724221e9dIMG_8663-1-155x105.jpg";
//timestamp = 1561662000;
//timestampms = 1561662000000;
//title = "No Reserve: 2008 BMW Alpina B7";
//titlesub = "Sold for $26,000 on 6/27/19";
//url = "https://bringatrailer.com/listing/2008-bmw-alpina-b7-4/";
