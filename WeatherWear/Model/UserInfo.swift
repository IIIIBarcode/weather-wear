//
//  UserInfo.swift
//  WeatherWear
//
//  Created by t2023-m079 on 2023/09/25.
//

import Foundation
class UserInfo {
    
    var isMetric: Bool
    var city: String
    var coldSensibility: Int
    
    init(isMetric: Bool, city: String, coldSensibility: Int) {
        self.isMetric = isMetric
        self.city = city
        self.coldSensibility = coldSensibility
    }
    
}

let user = UserInfo(isMetric: true, city: "서울특별시", coldSensibility: 0)
