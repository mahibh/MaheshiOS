//
//  CitiyClass.swift
//  SearchCityApp
//
//  Created by User on 19/06/19.
//  Copyright © 2019 Heena. All rights reserved.
//

import UIKit
import CoreLocation

class CityClass: NSObject {

    var cityId : Int?
    var country : String?
    var coord : CLLocationCoordinate2D?
    var name : String?
    
    init(UserDict:[String:Any]?){
        if UserDict != nil
        {
            self.name = UserDict?["name"] as? String
            self.country = UserDict?["country"] as? String
            let cord = UserDict?["coord"] as? [String:Any]
            self.coord = CLLocationCoordinate2D(latitude: cord?["lat"] as? Double ?? 0.0, longitude: cord?["lon"] as? Double ?? 0.0)
            self.cityId = UserDict?["_id"] as? Int
        }
    }
}
