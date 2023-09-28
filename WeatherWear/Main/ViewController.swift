//
//  ViewController.swift
//  WeatherWear
//
//  Created by Future on 2023/09/25.
//

import UIKit

class ViewController: UIViewController {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    
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
        segmentedControl.backgroundColor = .white.withAlphaComponent(0.15)
        
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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: self.view.frame.width / 8, height: 120)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WeatherHourCell.self, forCellWithReuseIdentifier: "WeatherHourCell")
        return collectionView
    }()
    
    private lazy var feedbackButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        btn.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        btn.layer.cornerRadius = 10
        btn.setTitleColor(.white, for: .normal)
        view.addSubview(btn)
        return btn
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dashicons_welcome-write-blog")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let feedbackRecommendationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        
        let attributedString = NSAttributedString(
            string: "오늘의 추천 옷차림은 어떠셨나요?\n피드백을 남기고 나에게 꼭 맞는 옷차림 추천을 받아보세요 (클릭하여 설문 작성)",
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        label.attributedText = attributedString
        
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
   
    
    
    
    @objc func clickBtn() {
        //        guard let feedbackViewController = self.storyboard?.instantiateViewController(withIdentifier: "Feedback") else {return}
        let feedbackViewController = FeedbackViewController()
        self.navigationController?.pushViewController(feedbackViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: feedbackButton.frame.maxY)
    }
    
    
    func setBackgroundImage() {
        if let backgroundImage = UIImage(named: "backgroundSample") {
            self.view.layer.contents = backgroundImage.cgImage
        }
    }
    
    func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
    }
    
    
    func setupUI() {
        setBackgroundImage()
        setupNavigationBarAppearance()
       
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(searchBar)
        contentView.addSubview(locationLabel)
        contentView.addSubview(gpsButton)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(temperatureSegmentedControl)
        contentView.addSubview(highestTemperatureLabel)
        contentView.addSubview(lowestTemperatureLabel)
        contentView.addSubview(clothesTitleLabel)
        contentView.addSubview(clothesItemsLabel)
        contentView.addSubview(belongingsTitleLabel)
        contentView.addSubview(belongingsItemsLabel)
        contentView.addSubview(separatorView)
        contentView.addSubview(weatherInfoContainerView)
        weatherInfoContainerView.addSubview(weatherStackView)
        weatherInfoContainerView.addSubview(weatherCommentLabel)
        contentView.addSubview(feedbackButton)
        contentView.addSubview(collectionView)
        self.view.bringSubviewToFront(scrollView)
        contentView.addSubview(feedbackButton)
        feedbackButton.addSubview(iconImageView)
        feedbackButton.addSubview(feedbackRecommendationLabel)
        scrollView.contentInsetAdjustmentBehavior = .never
        
        setupConstraints()
    }
    
    
    func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: feedbackButton.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 54),
            searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
        ])
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 30),
            locationLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20)
        ])
        
        gpsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gpsButton.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor),
            gpsButton.leadingAnchor.constraint(equalTo: locationLabel.trailingAnchor, constant: 10)
        ])
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            temperatureLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor)
        ])
        
        temperatureSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            temperatureSegmentedControl.bottomAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: -20),
            temperatureSegmentedControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
        
        lowestTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lowestTemperatureLabel.bottomAnchor.constraint(equalTo: temperatureSegmentedControl.topAnchor, constant: -10),
            lowestTemperatureLabel.trailingAnchor.constraint(equalTo: temperatureSegmentedControl.trailingAnchor)
        ])
        
        highestTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            highestTemperatureLabel.bottomAnchor.constraint(equalTo: lowestTemperatureLabel.topAnchor, constant: -5),
            highestTemperatureLabel.trailingAnchor.constraint(equalTo: temperatureSegmentedControl.trailingAnchor)
        ])
        
        clothesTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clothesTitleLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 30),
            clothesTitleLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor, constant: 5)
        ])
        
        clothesItemsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clothesItemsLabel.topAnchor.constraint(equalTo: clothesTitleLabel.bottomAnchor, constant: 10),
            clothesItemsLabel.leadingAnchor.constraint(equalTo: clothesTitleLabel.leadingAnchor)
        ])
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: clothesTitleLabel.topAnchor),
            separatorView.bottomAnchor.constraint(equalTo: clothesItemsLabel.bottomAnchor),
            separatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            separatorView.widthAnchor.constraint(equalToConstant: 1)
        ])
        
        belongingsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            belongingsTitleLabel.topAnchor.constraint(equalTo: clothesTitleLabel.topAnchor),
            belongingsTitleLabel.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 30)
        ])
        
        belongingsItemsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            belongingsItemsLabel.topAnchor.constraint(equalTo: belongingsTitleLabel.bottomAnchor, constant: 10),
            belongingsItemsLabel.leadingAnchor.constraint(equalTo: belongingsTitleLabel.leadingAnchor)
        ])
        
        weatherInfoContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherInfoContainerView.topAnchor.constraint(equalTo: clothesItemsLabel.bottomAnchor, constant: 30),
            weatherInfoContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            weatherInfoContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
        
        weatherStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherStackView.topAnchor.constraint(equalTo: weatherInfoContainerView.topAnchor, constant: 10),
            weatherStackView.centerXAnchor.constraint(equalTo: weatherInfoContainerView.centerXAnchor)
        ])
        
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 25),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        weatherCommentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherCommentLabel.topAnchor.constraint(equalTo: weatherIconImageView.bottomAnchor, constant: 10),
            weatherCommentLabel.leadingAnchor.constraint(equalTo: weatherInfoContainerView.leadingAnchor, constant: 20),
            weatherCommentLabel.trailingAnchor.constraint(equalTo: weatherInfoContainerView.trailingAnchor, constant: -20),
            weatherCommentLabel.bottomAnchor.constraint(equalTo: weatherInfoContainerView.bottomAnchor, constant: -10)
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: weatherInfoContainerView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        feedbackButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feedbackButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 25),
            feedbackButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            feedbackButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            feedbackButton.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: feedbackButton.leadingAnchor, constant: 10),
            iconImageView.centerYAnchor.constraint(equalTo: feedbackButton.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 47),
            iconImageView.heightAnchor.constraint(equalToConstant: 47)
        ])
        
        feedbackRecommendationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feedbackRecommendationLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            feedbackRecommendationLabel.centerYAnchor.constraint(equalTo: feedbackButton.centerYAnchor),
            feedbackRecommendationLabel.trailingAnchor.constraint(equalTo: feedbackButton.trailingAnchor, constant: -10)
        ])
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherHourCell", for: indexPath) as! WeatherHourCell
        
        cell.setHour(indexPath.item * 3)
        return cell
    }
}
