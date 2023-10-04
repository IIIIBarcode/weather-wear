//
//  AccessoriesInfo.swift
//  WeatherWear
//
//  Created by t2023-m079 on 2023/09/25.
//

import Foundation
struct AccessoriesInfo {
    
    let name: String
    let weatherType: String

}

let suncream = AccessoriesInfo(name: "썬크림", weatherType: "Clear")
let cap = AccessoriesInfo(name: "캡모자", weatherType: "Clear")
let water = AccessoriesInfo(name: "물", weatherType: "Clear")
let littleUmbrella = AccessoriesInfo(name: "작은 우산", weatherType: "Clouds")
let warmDrink = AccessoriesInfo(name: "따뜻한 음료", weatherType: "Clouds")
let umbrella = AccessoriesInfo(name: "우산", weatherType: "Rain")
let rainBoots = AccessoriesInfo(name: "레인 부츠", weatherType: "Rain")
let rainCoat = AccessoriesInfo(name: "우비", weatherType: "Rain")
let snowUmbrella = AccessoriesInfo(name: "우산", weatherType: "Snow")
let gloves = AccessoriesInfo(name: "장갑", weatherType: "Snow")

let accessories = [suncream, cap, water, littleUmbrella, warmDrink, umbrella, rainBoots, rainCoat, snowUmbrella, gloves]
