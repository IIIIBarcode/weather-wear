//
//  ViewController.swift
//  WeatherWear
//
//  Created by t2023-m079 on 10/4/23.
//

import Foundation
import UIKit

extension UIViewController {
    func setBackgroundImage(_ weather: String) {
        var imageName = ""
        switch weather {
        case "Clear": imageName = "sunnyBackground"
        case "Clouds": imageName = "cloudyBackground"
        case "Rain": imageName = "rainyBackground"
        case "Snow": imageName = "snowyBackground"
        case "Thunderstorm": imageName = "thnderstormBackground"
        case "Drizzle": imageName = "drizzleBackground"
        default: imageName = "cloudyBackground"
        }
        if let backgroundImage = UIImage(named: imageName) {
            self.view.layer.contents = backgroundImage.cgImage
        }
    }
}
