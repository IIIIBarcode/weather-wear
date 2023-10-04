//
//  FeedbackViewController.swift
//  WeatherWear
//
//  Created by 정기현 on 2023/09/26.
//

import UIKit
import SnapKit

class FeedbackViewController: UIViewController {
    var satisfyButton: UIButton!
    var dissatisfyButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigureUI()
        // Do any additional setup after loading the view.
    }
    
    
    func ConfigureUI() {
        setBackgroundImage(weatherBackgroundName)
        view.backgroundColor = .black
        let iconImage = UIImageView()
        view.addSubview(iconImage)
        iconImage.image = UIImage(named: "dashicons_welcome-write-blog")
        iconImage.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.height.equalTo(47)
        }
        
        let mainTitleLabel = UILabel()
        view.addSubview(mainTitleLabel)
        mainTitleLabel.text = "오늘 옷차림 추천 서비스는 만족스러우셨나요?"
        mainTitleLabel.textColor = .systemBackground
        mainTitleLabel.textAlignment = .center
        mainTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(iconImage.snp.bottom).offset(50)
        }
        
        let subTitleLabel = UILabel()
        view.addSubview(subTitleLabel)
        subTitleLabel.text = "(아래의 오늘의 추천 옷차림을 참고하여 답변해주세요)"
        subTitleLabel.textColor = .systemBackground
        subTitleLabel.font = UIFont.systemFont(ofSize: 14)
        subTitleLabel.textAlignment = .center
        subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(10)
        }
        
        let titleLabel = UILabel()
        view.addSubview(titleLabel)
        titleLabel.text = "오늘의 추천 옷차림"
        titleLabel.textColor = .systemBackground
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(20)
        }
        
        let clotheLabel = UILabel()
        view.addSubview(clotheLabel)
        clotheLabel.text = "반팔, 얇은 셔츠\n 반바지, 면바지"
        clotheLabel.numberOfLines = 0
        clotheLabel.textColor = .systemBackground
        clotheLabel.font = UIFont.systemFont(ofSize: 13)
        let attrString = NSMutableAttributedString(string: clotheLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        clotheLabel.attributedText = attrString
        clotheLabel.textAlignment = .center
        clotheLabel.layer.borderWidth = 1
        clotheLabel.layer.borderColor = UIColor.white.cgColor
        clotheLabel.layer.cornerRadius = 5
        clotheLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalTo(view.safeAreaLayoutGuide).offset(-70)
            make.width.equalTo(120)
            make.height.equalTo(60)
        }
        
        let accessoryLabel = UILabel()
        view.addSubview(accessoryLabel)
        accessoryLabel.text = "우산, 우비\n 레인부츠"
        accessoryLabel.numberOfLines = 0
        accessoryLabel.textColor = .systemBackground
        accessoryLabel.font = UIFont.systemFont(ofSize: 13)
        let attrString2 = NSMutableAttributedString(string: accessoryLabel.text!)
        paragraphStyle.lineSpacing = 10
        attrString2.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString2.length))
        accessoryLabel.attributedText = attrString2
        accessoryLabel.textAlignment = .center
        accessoryLabel.layer.borderWidth = 1
        accessoryLabel.layer.borderColor = UIColor.white.cgColor
        accessoryLabel.layer.cornerRadius = 5
        accessoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalTo(view.safeAreaLayoutGuide).offset(70)
            make.width.equalTo(120)
            make.height.equalTo(60)
        }
        
        satisfyButton = UIButton()
        view.addSubview(satisfyButton)
        satisfyButton.backgroundColor = .separator
        satisfyButton.setTitle("a. 만족해요", for: .normal)
        satisfyButton.setTitleColor(.white, for: .normal)
        satisfyButton.layer.cornerRadius = 10
        satisfyButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(clotheLabel.snp.bottom).offset(30)
            make.width.equalTo(280)
            make.height.equalTo(60)
        }
        
        dissatisfyButton = UIButton()
        view.addSubview(dissatisfyButton)
        dissatisfyButton.backgroundColor = .separator
        dissatisfyButton.setTitle("b. 아쉬워요", for: .normal)
        dissatisfyButton.setTitleColor(.white, for: .normal)
        dissatisfyButton.layer.cornerRadius = 10
        dissatisfyButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(satisfyButton.snp.bottom).offset(30)
            make.width.equalTo(280)
            make.height.equalTo(60)
        }
        
        let confirmButton = UIButton()
        view.addSubview(confirmButton)
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.layer.cornerRadius = 10
        confirmButton.layer.borderWidth = 1
        confirmButton.layer.borderColor = UIColor.white.cgColor
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.width.equalTo(280)
            make.height.equalTo(60)
        }
        satisfyButton.addTarget(self, action: #selector(satisfyButtonClick), for: .touchUpInside)
        dissatisfyButton.addTarget(self, action: #selector(dissatisfyButtonClick), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmButtonClick), for: .touchUpInside)
    }
    @objc func satisfyButtonClick(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
            dissatisfyButton.isSelected = false
            dissatisfyButton.backgroundColor = .separator
            dissatisfyButton.setTitleColor(.white, for: .normal)
        }
        else {
            sender.backgroundColor = .separator
            sender.setTitleColor(.white, for: .normal)
        }
    }
    
    
    @objc func dissatisfyButtonClick(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
            satisfyButton.isSelected = false
            satisfyButton.backgroundColor = .separator
            satisfyButton.setTitleColor(.white, for: .normal)
        }
        else {
            sender.backgroundColor = .separator
            sender.setTitleColor(.white, for: .normal)
        }
    }
    
    @objc func confirmButtonClick(_ sender: UIButton) {
        if satisfyButton.isSelected {
            self.navigationController?.popViewController(animated: true)
            
        }
        else if dissatisfyButton.isSelected {
            let surveyViewController = SurveyViewController()
            navigationController?.pushViewController(surveyViewController, animated: true)
        }
        else {
            showToast(message: "항목을 선택해주세요")
        }
    }
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
            let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.font = font
            toastLabel.textAlignment = .center;
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
                 toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
}
