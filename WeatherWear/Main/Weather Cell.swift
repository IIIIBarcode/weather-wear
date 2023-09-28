//
//  Weather Cell.swift
//  WeatherWear
//
//  Created by FUTURE on 2023/09/27.
//

import UIKit
import SnapKit

class WeatherHourCell: UICollectionViewCell {
    
    private let hourLabel: UILabel = {
        let label = UILabel()
        label.text = "0시"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rainIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "20°"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHour(_ hour: Int) {
        hourLabel.text = "\(hour)시"
    }
    
    private func setupUI() {
        addSubview(hourLabel)
        addSubview(weatherIconImageView)
        addSubview(temperatureLabel)
        
        hourLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
        }
        
        weatherIconImageView.snp.makeConstraints { make in
            make.top.equalTo(hourLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherIconImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}
