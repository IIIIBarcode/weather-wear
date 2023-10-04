//
//  WeatherInfo.swift
//  WeatherWear
//
//  Created by t2023-m079 on 2023/09/25.
//

import Foundation
struct WeatherInfo { //구의강변로 94
    
    let temp: Int
    let date: String
    let weather: String
    let precipitation: Int
    let pop: Int
    
}
var lat = ""
var lon = ""


var nowWeather = WeatherInfo(temp: 0, date: "", weather: "", precipitation: 0, pop: 0)
var weeklyWeather: [WeatherInfo] = []
