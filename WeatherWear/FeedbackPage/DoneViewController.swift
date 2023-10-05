//
//  DoneViewController.swift
//  WeatherWear
//
//  Created by t2023-m079 on 2023/09/29.
//

import UIKit

class DoneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        goToMain()
    }
    func goToMain() {
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + 1) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    func configureUI() {
        setBackgroundImage(nowWeather.weather)
        self.navigationItem.hidesBackButton = true
//        self.tabBarController?.tabBar.isHidden = true
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Group 45")
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "작성해주신 답변을 토대로\n더 알맞는 옷차림을 추천해드리겠습니다 !"
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        let attrString = NSMutableAttributedString(string: titleLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        titleLabel.attributedText = attrString
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
}
