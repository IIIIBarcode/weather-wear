//
//  WeeklyWearViewController.swift
//  WeatherWear
//
//  Created by 정기현 on 2023/09/26.
//

import SnapKit
import UIKit
class WeeklyWearViewController: UIViewController {
    lazy var location: UILabel = {
        let lb = UILabel()
        lb.text = "서울특별시"
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
        view.addSubview(btn)
        return btn

    }()

    lazy var isMetricBtn: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["섭씨", "화씨"])
        seg.tintColor = .white
        seg.selectedSegmentTintColor = .white
        seg.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        view.addSubview(seg)
        seg.selectedSegmentIndex = 0

        return seg
    }()

    let searchController: UISearchController = {
        let serch = UISearchController(searchResultsController: nil)

        serch.obscuresBackgroundDuringPresentation = false
        serch.searchBar.placeholder = "Search"
        serch.searchBar.tintColor = .white

        return serch
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
        setBackgroundImage()
        setting()
    }
}

extension WeeklyWearViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {}
}

extension WeeklyWearViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeekCell", for: indexPath) as! WeeklyTableViewCell // 사용자 정의 셀 클래스로 캐스팅해야 합니다.

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
    }

    func setBackgroundImage() {
        if let backgroundImage = UIImage(named: "backgroundSample") {
            view.layer.contents = backgroundImage.cgImage
        }
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
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}
