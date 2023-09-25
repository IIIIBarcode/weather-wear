//
//  UserInfo.swift
//  WeatherWear
//
//  Created by t2023-m079 on 2023/09/25.
//

import Foundation
class UserInfo {
    
    let isMetric: Bool
    let city: String
    let coldSensibility: Int
    
    init(isMetric: Bool, city: String, coldSensibility: Int) {
        self.isMetric = isMetric
        self.city = city
        self.coldSensibility = coldSensibility
    }
    
}
