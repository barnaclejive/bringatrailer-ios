//
//  Parser.swift
//  bat
//
//  Created by Mike Peterson on 7/27/19.
//  Copyright © 2019 foobax. All rights reserved.
//

import Foundation
import Kanna
import Alamofire

class Parser {
    
    static func getCars(searchTerm: String, callback: @escaping (_ cars: [Car]) -> ()) {
        
        let parameters: Parameters = ["s": searchTerm]
        
        Alamofire.request("https://bringatrailer.com/search", method: .get, parameters: parameters, headers: nil).responseString { response in
            
            if let html = response.result.value {
                
                let cars = self.parseCars(html: html)
                callback(cars)
            }
        }
    }
    
    private static func parseCars(html: String) -> [Car] {
        
        var cars = [Car]()
        
        guard let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) else {
            print("no doc")
            return cars
        }
        
        guard let chart = doc.css(".chart[data-stats]").first else {
            print("no chart")
            return cars
        }
        
        guard let jsonString = chart["data-stats"] else {
            print("no data-stats")
            return cars
        }
        
        guard let data = jsonString.data(using: String.Encoding.utf8) else {
            print("can't convert string to data")
            return cars
        }
        
        guard let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]  else {
            print("dict error")
            return cars
        }
        
        // sold
        guard let soldCarJsons = dict["s"] as? [AnyObject] else {
            print("no cars (missing s element)")
            return cars
        }
        for carJson in soldCarJsons {
            cars.append(Car(data: carJson))
        }
        
        // unsold
        guard let unsoldCarJsons = dict["u"] as? [AnyObject] else {
            print("no cars (missing s element)")
            return cars
        }
        for carJson in unsoldCarJsons {
            cars.append(Car(data: carJson))
        }
        
        return cars
    }
    
}
