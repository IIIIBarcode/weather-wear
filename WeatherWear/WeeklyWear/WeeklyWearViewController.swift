//
//  WeeklyWearViewController.swift
//  WeatherWear
//
//  Created by 정기현 on 2023/09/26.
//

import SnapKit
import UIKit
import CoreLocation


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
//        lb.text = "서울특별시"
        lb.text = user.city
        lb.font = .systemFont(ofSize: 40, weight: .bold)
        lb.textColor = .white
        lb.textAlignment = .left
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        weakTable.reloadData()
    }
}

extension WeeklyWearViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {}
}

extension WeeklyWearViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyWeather.count/2
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
            make.height.equalTo(50)
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
}

extension WeeklyWearViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            print("위도: \(latitude), 경도: \(longitude)")
        }
        locationManager.stopUpdatingLocation() // 위치 업데이트를 중단하여 사용자의 배터리를 절약하는 코드
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error.localizedDescription)")
    }
}
