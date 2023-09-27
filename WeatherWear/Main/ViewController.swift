//
//  ViewController.swift
//  WeatherWear
//
//  Created by Future on 2023/09/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.barStyle = .default
        searchBar.tintColor = .white
        
        // 텍스트필드의 text, placeholder, 및 background 설정
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .white
            textField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            textField.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            
            // 돋보기 아이콘 색상
            let glassIconView = textField.leftView as? UIImageView
            glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
            glassIconView?.tintColor = .white
        }
        
        return searchBar
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "서울특별시"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    private let gpsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "gpsIcon"), for: .normal)
        return button
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "22°"
        label.font = UIFont.systemFont(ofSize: 115)
        label.textColor = .white
        return label
    }()
    
    private let temperatureSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["⠀⠀⠀°C⠀⠀⠀", "⠀⠀⠀°F⠀⠀⠀"])
        segmentedControl.selectedSegmentIndex = 0
        
        // 선택되지 않은 부분 설정
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(textAttributes, for: .normal)
        
        // 선택된 부분 설정
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        return segmentedControl
    }()
        
    // 최고 온도 레이블
    private let highestTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "최고 22°"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    // 최저 온도 레이블
    private let lowestTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "최저 18°"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    // "오늘의 옷" 타이틀 레이블
    private let clothesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 옷"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    // "오늘의 옷" 아이템 레이블
    private let clothesItemsLabel: UILabel = {
        let label = UILabel()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        
        let attributedString = NSAttributedString(string: "반팔\n얇은 셔츠\n반바지\n면바지", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        label.attributedText = attributedString
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // "오늘의 소지품" 타이틀 레이블
    private let belongingsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 소지품"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    // "오늘의 소지품" 아이템 레이블
    private let belongingsItemsLabel: UILabel = {
        let label = UILabel()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        
        let attributedString = NSAttributedString(string: "우산\n우비\n레인부츠", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        label.attributedText = attributedString
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // 구분선
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    // 날씨 정보를 담을 뷰
    private let weatherInfoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        view.layer.cornerRadius = 10
        return view
    }()
    
    // 스택뷰 (날씨 아이콘 + 날씨 설명 레이블)
    private lazy var weatherStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weatherIconImageView, weatherDescriptionLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    // 날씨 아이콘
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rainIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // 날씨 설명 레이블
    private let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "비"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    // 날씨 코멘트 레이블
    private let weatherCommentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        
        let attributedString = NSAttributedString(string: "오늘은 50mm의 비가 예상됩니다. \n우산을 꼭 챙기세요. 창밖의 비를 감상하며 카페에서 커피를 마시는 것도 좋겠네요.", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        label.attributedText = attributedString
        label.textAlignment = .center
        
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            setupUI()
    }
    
    
    func setBackgroundImage() {
        if let backgroundImage = UIImage(named: "backgroundSample") {
            self.view.layer.contents = backgroundImage.cgImage
        }
    }
    
    
    func setupUI() {
        setBackgroundImage()
        
        //        self.view.backgroundColor = .black
        
        self.view.addSubview(searchBar)
        self.view.addSubview(locationLabel)
        self.view.addSubview(gpsButton)
        self.view.addSubview(temperatureLabel)
        self.view.addSubview(temperatureSegmentedControl)
        self.view.addSubview(highestTemperatureLabel)
        self.view.addSubview(lowestTemperatureLabel)
        self.view.addSubview(clothesTitleLabel)
        self.view.addSubview(clothesItemsLabel)
        self.view.addSubview(belongingsTitleLabel)
        self.view.addSubview(belongingsItemsLabel)
        self.view.addSubview(separatorView)
        self.view.addSubview(weatherInfoContainerView)
        weatherInfoContainerView.addSubview(weatherStackView)
        
        weatherInfoContainerView.addSubview(weatherCommentLabel)
        
        setupConstraints()
    }
    
    
    func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(20)
        }
        
        gpsButton.snp.makeConstraints { make in
            make.centerY.equalTo(locationLabel)
            make.leading.equalTo(locationLabel.snp.trailing).offset(10)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom)
            make.leading.equalTo(searchBar)
        }
        
        temperatureSegmentedControl.snp.makeConstraints { make in
            make.bottom.equalTo(temperatureLabel.snp.bottom).offset(-20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        lowestTemperatureLabel.snp.makeConstraints { make in
            make.bottom.equalTo(temperatureSegmentedControl.snp.top).offset(-10)
            make.trailing.equalTo(temperatureSegmentedControl)
        }
        
        highestTemperatureLabel.snp.makeConstraints { make in
            make.bottom.equalTo(lowestTemperatureLabel.snp.top).offset(-5)
            make.trailing.equalTo(temperatureSegmentedControl)
        }
        
        clothesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(30)
            make.leading.equalTo(searchBar).offset(10)
        }
        
        clothesItemsLabel.snp.makeConstraints { make in
            make.top.equalTo(clothesTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(clothesTitleLabel)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(clothesTitleLabel)
            make.bottom.equalTo(clothesItemsLabel)
            make.centerX.equalToSuperview()
            make.width.equalTo(1)
        }
        
        belongingsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(clothesTitleLabel)
            make.leading.equalTo(separatorView.snp.trailing).offset(30)
        }
        
        belongingsItemsLabel.snp.makeConstraints { make in
            make.top.equalTo(belongingsTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(belongingsTitleLabel)
        }
        
        weatherInfoContainerView.snp.makeConstraints { make in
            make.top.equalTo(clothesItemsLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        weatherStackView.snp.makeConstraints { make in
            make.top.equalTo(weatherInfoContainerView).offset(10)
            make.centerX.equalTo(weatherInfoContainerView)
        }
        
        weatherIconImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        
        weatherCommentLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherIconImageView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(weatherInfoContainerView).inset(20)
            make.bottom.equalTo(weatherInfoContainerView).offset(-10)
        }
    }
}
