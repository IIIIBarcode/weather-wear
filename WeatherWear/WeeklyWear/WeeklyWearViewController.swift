//
//  WeeklyWearViewController.swift
//  WeatherWear
//
//  Created by 정기현 on 2023/09/26.
//

import Alamofire
import CoreLocation
import SnapKit
import SwiftyJSON
import UIKit

class WeeklyWearViewController: UIViewController {
    let locationManager = CLLocationManager()

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

    lazy var location: UILabel = {
        let lb = UILabel()
        lb.text = "서울특별시"
        lb.font = .systemFont(ofSize: 25, weight: .bold)
        lb.textColor = .white
        lb.textAlignment = .left
        lb.numberOfLines = 0
        view.addSubview(lb)
        return lb
    }()

    lazy var mylacation: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "myLocation"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(getGPSLocation), for: .touchUpInside)
        view.addSubview(btn)
        return btn

    }()

    lazy var isMetricBtn: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["°C", "°F"])
        seg.tintColor = .white
        seg.selectedSegmentTintColor = .white
        seg.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        view.addSubview(seg)
        seg.selectedSegmentIndex = 0
        // 선택되지 않은 부분 설정
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        seg.setTitleTextAttributes(textAttributes, for: .normal)
        // 선택된 부분 설정
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        seg.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        seg.addTarget(self, action: #selector(switchTemp), for: .valueChanged)
        return seg
    }()

    lazy var weakTable: UITableView = {
        let tb = UITableView()
        tb.backgroundColor = .clear
        view.addSubview(tb)
        return tb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        makeUi()
        setBackgroundImage(weatherBackgroundName)
        setting()
        setupLocationManager()
        isMetricBtn.selectedSegmentIndex = user.isMetric ? 0 : 1
        searchBar.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        weakTable.reloadData()
        updateUI()
        isMetricBtn.selectedSegmentIndex = user.isMetric ? 0 : 1
    }

    @objc func switchTemp() {
        if isMetricBtn.selectedSegmentIndex == 0 {
            user.isMetric = true
        } else if isMetricBtn.selectedSegmentIndex == 1 {
            user.isMetric = false
        }
        weakTable.reloadData()
        print(user.isMetric)
    }
}

extension WeeklyWearViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {}
}

extension WeeklyWearViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyWeather.count / 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeekCell", for: indexPath) as! WeeklyTableViewCell // 사용자 정의 셀 클래스로 캐스팅해야 합니다.
        let weather1 = weeklyWeather[indexPath.row * 2]
        let weather2 = weeklyWeather[indexPath.row * 2 + 1]
        cell.configureUI(weather1, weather2)
        cell.selectionStyle = .none
        return cell
    }

    // 테이블뷰 높이 조절
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    // 시스템백그라운드 색상
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}

extension WeeklyWearViewController {
    func updateUI() {
        location.text = user.city
        setBackgroundImage(nowWeather.weather)
    }

    func setting() {
        weakTable.register(WeeklyTableViewCell.self, forCellReuseIdentifier: "WeekCell")
        weakTable.dataSource = self
        weakTable.delegate = self
        navigationItem.titleView = searchBar
    }

    func makeUi() {
        location.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading).inset(20)
//            make.height.equalTo(50)
            make.width.equalTo(300)
        }
        mylacation.snp.makeConstraints { make in
            make.leading.equalTo(location.snp.trailing).inset(-10)
            make.centerY.equalTo(location.snp.centerY)
            make.width.height.equalTo(30)
        }
        isMetricBtn.snp.makeConstraints { make in
            make.top.equalTo(location.snp.bottom).inset(-10)
            make.leading.equalTo(location.snp.leading)
            make.width.equalTo(148)
            make.height.equalTo(27)
        }
        weakTable.snp.makeConstraints { make in
            make.top.equalTo(isMetricBtn.snp.top).inset(60)
            make.leading.equalTo(isMetricBtn.snp.leading)
            make.trailing.equalTo(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    @objc func getGPSLocation() {
        locationManager.startUpdatingLocation()
    }

    func getWeeklyWeather() {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(openweatherApiKey)&units=metric"
        ) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self,
                  let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            else {
                return
            }

            // API에서 받아온 데이터를 파싱하여 WeatherInfo 객체로 변환하고 배열에 저장
            let list = json["list"] as! [[String: Any]]
            weatherData = []
            for item in list {
                let date = item["dt_txt"] as! String // 예보시간
                let main = item["main"] as! [String: Any]
                let temp = main["temp"] as! Double // 기온
                let weather = item["weather"] as! [[String: Any]]
                let weatherState = weather[0]["main"] as! String // 날씨상태
                let pop = item["pop"] as! Double // 강수확률
                let rain = item["rain"] as? [String: Any]
                let precipitation = rain?["3h"] as? Double // 3시간당 강수량
                let weatherinfo = WeatherInfo(temp: Int(temp), date: date, weather: weatherState, precipitation: Int((precipitation ?? 0) * 100), pop: Int(pop * 100))
                weatherData.append(weatherinfo)
            }

            // UI 업데이트는 메인 스레드에서 수행해야 함
            DispatchQueue.main.async {
                updateWeeklyWeather()
                self.weakTable.reloadData()
            }
        }.resume()
    }

    func getAddress(_ lat: String, _ lon: String) {
        let Reverse_NAVER_GEOCODE_URL = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords="
        let latlon = lon + "," + lat
        let header1 = HTTPHeader(name: "X-NCP-APIGW-API-KEY-ID", value: Reverse_NAVER_CLIENT_ID)
        let header2 = HTTPHeader(name: "X-NCP-APIGW-API-KEY", value: Reverse_NAVER_CLIENT_SECRET)
        let headers = HTTPHeaders([header1, header2])
        AF.request(Reverse_NAVER_GEOCODE_URL + "\(latlon)&output=json", method: .get, headers: headers).validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value as [String: Any]):
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
                        self.location.text = user.city
                    }
                case .failure(let error):
                    let alert = UIAlertController(title: nil, message: "주소를 제대로 입력하세요 \n 국내만 제공됩니다.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(ok)
                    self.present(alert, animated: true)
                    print(error.errorDescription ?? "")
                default:
                    fatalError()
                }
            }
    }

    func getCoordinate(_ address: String) {
        let NAVER_GEOCODE_URL = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query="
        let encodeAddress = address.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let header1 = HTTPHeader(name: "X-NCP-APIGW-API-KEY-ID", value: NAVER_CLIENT_ID)
        let header2 = HTTPHeader(name: "X-NCP-APIGW-API-KEY", value: NAVER_CLIENT_SECRET)
        let headers = HTTPHeaders([header1, header2])
        AF.request(NAVER_GEOCODE_URL + encodeAddress, method: .get, headers: headers).validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value as [String: Any]):
                    let json = JSON(value)
                    let data = json["addresses"]
                    let ad = data[0]["roadAddress"]
                    let apilat = data[0]["y"]
                    let apilon = data[0]["x"]
                    DispatchQueue.main.async {
                        if ad.stringValue == "" {
                            let alert = UIAlertController(title: nil, message: "주소를 제대로 입력하세요 \n 국내만 제공됩니다.", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default)
                            alert.addAction(ok)
                            self.present(alert, animated: true)
                        } else {
                            self.location.text = ad.stringValue
                            user.city = ad.stringValue
                            lat = apilat.stringValue
                            lon = apilon.stringValue
                            self.getNowWeather()
                            self.getWeeklyWeather()
                        }
                    }
                // 제주
                case .failure(let error):
                    print(error.errorDescription ?? "")
                default:
                    fatalError()
                }
            }
    }

    func getNowWeather() {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(openweatherApiKey)&units=metric"
        ) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self,
                  let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            else {
                return
            }
            let weather = json["weather"] as? [[String: Any]]
            let weatherState = weather?[0]["main"] as! String
            let main = json["main"] as! [String: Any]
            let temp = main["temp"] as? Double
            let tempMin = main["temp_min"] as? Double
            let tempMax = main["temp_max"] as? Double
            let rain = json["rain"] as? [String: Double]
            let precipitation = (rain?["1h"] ?? 0) * 100

            DispatchQueue.main.async {
                nowWeather.temp = Int(temp!)
                nowWeather.weather = weatherState
                nowWeather.precipitation = Int(precipitation)
                nowTempMax = Int(tempMax!)
                nowTempMin = Int(tempMin!)
                self.setBackgroundImage(nowWeather.weather)
            } // 구의동 독도
        }.resume()
    }
}

extension WeeklyWearViewController: CLLocationManagerDelegate {
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

extension WeeklyWearViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let address = searchBar.text
        getCoordinate(address ?? "")
    }
}
