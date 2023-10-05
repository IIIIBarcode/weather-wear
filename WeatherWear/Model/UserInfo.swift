//
//  UserInfo.swift
//  WeatherWear
//
//  Created by t2023-m079 on 2023/09/25.
//

import Foundation
class UserInfo: Codable {
    
    var isMetric: Bool
    var city: String
    var coldSensibility: Int
    
    init(isMetric: Bool, city: String, coldSensibility: Int) {
        self.isMetric = isMetric
        self.city = city
        self.coldSensibility = coldSensibility
    }
    
} 

var user = UserInfo(isMetric: true, city: "서울특별시", coldSensibility: 0)

class UserManager {
    static let shared = UserManager() // Singleton instance
    let encoder = JSONEncoder()
    func SaveUser() {
        if let encodedUser = try? encoder.encode(user) {
            UserDefaults.standard.set(encodedUser, forKey: "User")
        }
    }
    
    func LoadUser() {
        if let savedUser = UserDefaults.standard.object(forKey: "User") as? Data {
            let decoder = JSONDecoder()
            if let savedObject = try? decoder.decode(UserInfo.self, from: savedUser) {
                user = savedObject
            }
        }
    }
        
        
    
}
