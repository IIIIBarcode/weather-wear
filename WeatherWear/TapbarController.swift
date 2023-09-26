//
//  TapbarController.swift
//  WeatherWear
//
//  Created by 정기현 on 2023/09/26.
//

import UIKit

class TapbarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllerSetting()
        self.tabBarSetting()
    }

    private func tabBarSetting() {
        self.tabBar.backgroundColor = .red
        self.modalPresentationStyle = .fullScreen
        self.tabBar.unselectedItemTintColor = .systemGray
        self.tabBar.tintColor = .black
    }

    private func viewControllerSetting() {
        let vc1 = UINavigationController(rootViewController: ViewController())
        let vc2 = UINavigationController(rootViewController: WeeklyWearViewController())
        vc1.tabBarItem = UITabBarItem(title: "오늘 뭐 입지?", image: nil, selectedImage: nil)
        vc2.tabBarItem = UITabBarItem(title: "이번주 뭐 입지?", image: nil, selectedImage: nil)
//        vc1.title = "홈"
//        vc2.tabBarItem.title = "좋아요"

        setViewControllers([vc1, vc2], animated: false)

//        guard let items = tabBar.items else { return }
    }
}
