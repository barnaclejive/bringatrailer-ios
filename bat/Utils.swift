//
//  Utils.swift
//  bat
//
//  Created by Mike Peterson on 7/27/19.
//  Copyright © 2019 foobax. All rights reserved.
//

import Foundation

let CURRENCY_FORMATTER = CurrencyFormatter.sharedInstance

class CurrencyFormatter: NumberFormatter {
    
    override init() {
        super.init()
        self.locale = Locale(identifier: "en_US")
        self.maximumFractionDigits = 2
        self.minimumFractionDigits = 2
        self.alwaysShowsDecimalSeparator = true
        self.numberStyle = .currency
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    static let sharedInstance = CurrencyFormatter()
}

let DATE__MMddyyyy_FORMATTER = DateMMddyyyyFormatter.sharedInstance

class DateMMddyyyyFormatter: DateFormatter {
    
    override init() {
        super.init()
        self.locale = Locale.current
        self.dateFormat = "MM/dd/yyyy"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    static let sharedInstance = DateMMddyyyyFormatter()
}

func dateFromJavaTimeStamp(_ timestamp: Date) -> Date {
    return Date(timeIntervalSince1970: (timestamp.timeIntervalSince1970 / 1000))
}
