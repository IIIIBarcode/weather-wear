//
//  WeatherInfo.swift
//  WeatherWear
//
//  Created by t2023-m079 on 2023/09/25.
//

import Foundation
struct WeatherInfo { //구의강변로 94
    
    var temp: Int
    var date: String
    var weather: String
    var precipitation: Int
    var pop: Int
    
}
var lat = ""
var lon = ""

var weatherBackgroundName = nowWeather.weather
var nowWeather = WeatherInfo(temp: 0, date: "", weather: "", precipitation: 0, pop: 0)
var nowTempMax = 0
var nowTempMin = 0
var weatherData: [WeatherInfo] = []
var weeklyWeather: [WeatherInfo] = []

func updateWeeklyWeather() {
    weeklyWeather = []
    var tempWeeklyWeather:[WeatherInfo] = []
    var tempWeatherData = weatherData
    for weather in tempWeatherData {
        let date = weather.date
        let startindex = date.index(date.startIndex, offsetBy: 0)
        let endindex = date.index(date.startIndex, offsetBy: 10)
        let time = date.substring(with: startindex..<endindex)
        if time != Date().toString("yyyy-MM-dd") {
            tempWeeklyWeather.append(weather)
        }
    }
    var day = 0
    var count = 0
    var tempMin = 0
    var tempMax = 0
    var weatherState1 = ""
    var weatherState2 = ""
    var pop1 = 0
    var pop2 = 0
    for weather in tempWeeklyWeather {
        if count == 0 {
            tempMin = weather.temp
            tempMax = weather.temp
        }
        count += 1
        if tempMin > weather.temp {
            tempMin = weather.temp
        }
        if tempMax < weather.temp {
            tempMax = weather.temp
        }
        if count == 4 {
            weatherState1 = weather.weather
            pop1 = weather.pop
        }
        if count == 6 {
            weatherState2 = weather.weather
            pop2 = weather.pop
        }
        if count == 8 {
            weeklyWeather.append(WeatherInfo(temp: tempMax, date: weather.date, weather: weatherState1, precipitation: 0, pop: pop1))
            weeklyWeather.append(WeatherInfo(temp: tempMin, date: weather.date, weather: weatherState2, precipitation: 0, pop: pop2))
            count = 0
            day += 1
        }
        if day == 4 {
            break
        }
    }
}
