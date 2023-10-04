//
//  SurveyViewController.swift
//  WeatherWear
//
//  Created by t2023-m079 on 2023/09/27.
//

import UIKit

class SurveyViewController: UIViewController {
   
    var selection: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    func configureUI() {
        setBackgroundImage(weatherBackgroundName)
        let iconImage = UIImageView()
        view.addSubview(iconImage)
        iconImage.image = UIImage(named: "dashicons_welcome-write-blog")
        iconImage.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.height.equalTo(47)
        }
        
        let titleLabel = UILabel()
        view.addSubview(titleLabel)
        titleLabel.text = "오늘 날씨에 적절하다고 생각하는 옷차림을 골라주세요"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(iconImage.snp.bottom).offset(20)
        }
        
        let itemTableView = UITableView()
        itemTableView.delegate = self
        itemTableView.dataSource = self
        itemTableView.register(ItemTableViewCell.self, forCellReuseIdentifier: "ItemCell")
        itemTableView.backgroundColor = .clear
        view.addSubview(itemTableView)
        itemTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(100)
        }
        
        let confirmButton = UIButton()
        view.addSubview(confirmButton)
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.backgroundColor = .clear
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 10
        confirmButton.layer.borderWidth = 1
        confirmButton.layer.borderColor = UIColor.white.cgColor
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(itemTableView.snp.bottom).offset(20)
            make.width.equalTo(itemTableView.snp.width)
            make.height.equalTo(40)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        confirmButton.addTarget(self, action: #selector(confirmButtonClick), for: .touchUpInside)
    }
    
    @objc func confirmButtonClick(_ sender: UIButton) {
        if selection != nil{
            print(selection!)
            let doneViewController = DoneViewController()
            self.navigationController?.pushViewController(doneViewController, animated: true)
        }
        else {
            print("선택안함")
        }
        
    }
}

extension SurveyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemgroup.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let content: String = {
            var content = ""
            for item in itemgroup[indexPath.row] {
                content.append(item)
                if item != itemgroup[indexPath.row].last{
                    content.append(", ")
                }
            }
            return content
        }()
        cell.itemLabel.text = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection = indexPath.row
    }
    
}

