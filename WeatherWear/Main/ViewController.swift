//
//  ViewController.swift
//  WeatherWear
//
//  Created by Future on 2023/09/25.
//

import UIKit
import SnapKit
import SwiftyJSON
import Alamofire
import CoreLocation

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
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
        searchBar.returnKeyType = .search
        
        // 텍스트필드의 text, placeholder, 및 background 설정
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .white
            textField.attributedPlaceholder = NSAttributedString(string: "도로명 주소나 지역명을 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7)])
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
        label.text = " "
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var gpsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "gpsIcon"), for: .normal)
        button.addTarget(self, action: #selector(getGPSLocation), for: .touchUpInside)
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
    
    
    @objc func getGPSLocation() {
        locationManager.startUpdatingLocation()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        setupLocationManager()
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
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(30)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.width.equalTo(300)
        }
        
        gpsButton.snp.makeConstraints { make in
            make.centerY.equalTo(locationLabel.snp.centerY)
            make.leading.equalTo(locationLabel.snp.trailing).offset(10)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom)
            make.leading.equalTo(locationLabel.snp.leading)
        }
        
        temperatureSegmentedControl.snp.makeConstraints { make in
            make.bottom.equalTo(temperatureLabel.snp.bottom).offset(-20)
            make.trailing.equalTo(self.view.snp.trailing).offset(-20)
        }
        
        lowestTemperatureLabel.snp.makeConstraints { make in
            make.bottom.equalTo(temperatureSegmentedControl.snp.top).offset(-10)
            make.trailing.equalTo(temperatureSegmentedControl.snp.trailing)
        }
        
        highestTemperatureLabel.snp.makeConstraints { make in
            make.bottom.equalTo(lowestTemperatureLabel.snp.top).offset(-5)
            make.trailing.equalTo(temperatureSegmentedControl.snp.trailing)
        }
        
        clothesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(30)
            make.leading.equalTo(locationLabel.snp.leading).offset(5)
        }
        
        clothesItemsLabel.snp.makeConstraints { make in
            make.top.equalTo(clothesTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(clothesTitleLabel.snp.leading)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(clothesTitleLabel.snp.top)
            make.bottom.equalTo(clothesItemsLabel.snp.bottom)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(1)
        }
        
        belongingsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(clothesTitleLabel.snp.top)
            make.leading.equalTo(separatorView.snp.trailing).offset(30)
        }
        
        belongingsItemsLabel.snp.makeConstraints { make in
            make.top.equalTo(belongingsTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(belongingsTitleLabel.snp.leading)
        }
        
        weatherInfoContainerView.snp.makeConstraints { make in
            make.top.equalTo(clothesItemsLabel.snp.bottom).offset(30)
            make.leading.equalTo(self.view.snp.leading).offset(20)
            make.trailing.equalTo(self.view.snp.trailing).offset(-20)
        }
        
        weatherStackView.snp.makeConstraints { make in
            make.top.equalTo(weatherInfoContainerView.snp.top).offset(10)
            make.centerX.equalTo(weatherInfoContainerView.snp.centerX)
        }
        
        weatherIconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(25)
        }
        
        weatherCommentLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherIconImageView.snp.bottom).offset(10)
            make.leading.equalTo(weatherInfoContainerView.snp.leading).offset(20)
            make.trailing.equalTo(weatherInfoContainerView.snp.trailing).offset(-20)
            make.bottom.equalTo(weatherInfoContainerView.snp.bottom).offset(-10)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(weatherInfoContainerView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(120)
        }
        
        feedbackButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(25)
            make.leading.equalTo(self.view.snp.leading).offset(20)
            make.trailing.equalTo(self.view.snp.trailing).offset(-20)
            make.height.equalTo(100)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(feedbackButton.snp.leading).offset(10)
            make.centerY.equalTo(feedbackButton.snp.centerY)
            make.width.height.equalTo(47)
        }
        
        feedbackRecommendationLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.centerY.equalTo(feedbackButton.snp.centerY)
            make.trailing.equalTo(feedbackButton.snp.trailing).offset(-10)
            make.bottom.equalTo(contentView).offset(-20)
        }
    }
    //제주
    
    func getCoordinate(_ address: String) {
        
        let NAVER_GEOCODE_URL = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query="
        let encodeAddress = address.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let header1 = HTTPHeader(name: "X-NCP-APIGW-API-KEY-ID", value: NAVER_CLIENT_ID)
        let header2 = HTTPHeader(name: "X-NCP-APIGW-API-KEY", value: NAVER_CLIENT_SECRET)
        let headers = HTTPHeaders([header1,header2])
        AF.request(NAVER_GEOCODE_URL + encodeAddress, method: .get,headers: headers).validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value as [String:Any]):
                    let json = JSON(value)
                    let data = json["addresses"]
                    let ad = data[0]["roadAddress"]
                    let apilat = data[0]["y"]
                    let apilon = data[0]["x"]
                    DispatchQueue.main.async{
                        if ad.stringValue == "" {
                            let alert = UIAlertController(title: nil, message: "주소를 제대로 입력하세요 \n 국내만 제공됩니다.", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default)
                            alert.addAction(ok)
                            self.present(alert, animated: true)
                        }
                        else{
                            self.locationLabel.text = ad.stringValue
                            lat = apilat.stringValue
                            lon = apilon.stringValue
                            self.getNowWeather()
                            self.getWeeklyWeather()
                            
                        }
                        
                    }
                    //제주
                case .failure(let error):
                    print(error.errorDescription ?? "")
                default :
                    fatalError()
                }
            }
    }
    
    func getNowWeather() {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(openweatherApiKey)&units=metric"
        ) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self,
                  let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return}
            let weather = json["weather"] as? [[String: Any]]
            let weatherState = weather?[0]["main"] as? String
            let main = json["main"] as! [String: Any]
            let temp = main["temp"] as? Double
            let tempMin = main["temp_min"] as? Double
            let tempMax = main["temp_max"] as? Double
            
            DispatchQueue.main.async {
                self.temperatureLabel.text = "\(Int(temp!))°"
                self.highestTemperatureLabel.text = "최고 \(Int(tempMax!))°"
                self.lowestTemperatureLabel.text = "최저 \(Int(tempMin!))°"
            }//구의동
        }.resume()
    }
    
    func getWeeklyWeather() {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(openweatherApiKey)&units=metric"
        ) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self,
                  let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return}
            
            
            // API에서 받아온 데이터를 파싱하여 WeatherInfo 객체로 변환하고 배열에 저장
            let list = json["list"] as! [[String: Any]]
            weatherData = []
            for item in list{
                let date = item["dt_txt"] as! String // 예보시간
                let main = item["main"] as! [String : Any]
                let temp = main["temp"] as! Double //기온
                let weather = item["weather"] as! [[String: Any]]
                let weatherState = weather[0]["main"] as! String // 날씨상태
                let pop = item["pop"] as! Double //강수확률
                let rain = item["rain"] as? [String: Any]
                let precipitation = rain?["3h"] as? Double // 3시간당 강수량
                let weatherinfo = WeatherInfo(temp: Int(temp), date: date, weather: weatherState, precipitation: Int((precipitation ?? 0) * 100), pop: Int(pop * 100))
                weatherData.append(weatherinfo)
            }
            
            
            
            // UI 업데이트는 메인 스레드에서 수행해야 함
            DispatchQueue.main.async {
                updateWeeklyWeather()
                self.collectionView.reloadData()
            }
        }.resume()
        

    }
    
    func getAddress(_ lat: String, _ lon: String) {
        let Reverse_NAVER_GEOCODE_URL = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords="
        let latlon = lon + "," + lat
        let header1 = HTTPHeader(name: "X-NCP-APIGW-API-KEY-ID", value: Reverse_NAVER_CLIENT_ID)
        let header2 = HTTPHeader(name: "X-NCP-APIGW-API-KEY", value: Reverse_NAVER_CLIENT_SECRET)
        let headers = HTTPHeaders([header1,header2])
        AF.request(Reverse_NAVER_GEOCODE_URL + "\(latlon)&output=json", method: .get,headers: headers).validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value as [String:Any]):
                    print("성공")
                    let json = JSON(value)
                    let results = json["results"]
                    let region = results[0]["region"]
                    let name1 = region["area1"]["name"].stringValue
                    let name2 = region["area2"]["name"].stringValue
                    let name3 = region["area3"]["name"].stringValue
                    let name4 = region["area4"]["name"].stringValue
                    print("\(name1) \(name2) \(name3) \(name4)")
                    DispatchQueue.main.async {
                        user.city = "\(name1) \(name2) \(name3) \(name4)"
                        self.locationLabel.text = user.city
                    }
                case .failure(let error):
                    let alert = UIAlertController(title: nil, message: "주소를 제대로 입력하세요 \n 국내만 제공됩니다.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(ok)
                    self.present(alert, animated: true)
                    print(error.errorDescription ?? "")
                default :
                    fatalError()
                }
            }
    }
}




extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherHourCell", for: indexPath) as! WeatherHourCell
        if !weatherData.isEmpty {
            let weather = weatherData[indexPath.row]
            cell.congigureUI(weather: weather)
        }
        else {
            cell.setHour(indexPath.item * 3)
        }
        
        return cell
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            lat = String(latitude)
            lon = String(longitude)
            getAddress(lat, lon)
            getNowWeather()
            getWeeklyWeather()
            print("위도: \(latitude), 경도: \(longitude)")
        }
        locationManager.stopUpdatingLocation() // 위치 업데이트를 중단하여 사용자의 배터리를 절약하는 코드
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error.localizedDescription)")
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let address = searchBar.text
        getCoordinate(address ?? "")
    }
}
