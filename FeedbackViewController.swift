//
//  FeedbackViewController.swift
//  WeatherWear
//
//  Created by 정기현 on 2023/09/26.
//

import UIKit
import SnapKit

class FeedbackViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigureUI()
        // Do any additional setup after loading the view.
    }
    
    
    func ConfigureUI() {
        let titleLabel = UILabel()
        titleLabel.text = "오늘 옷차림 추천 서비스는 만족스러우셨나요?"
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        
        
        let clotheLabel = UILabel()
        clotheLabel.text = "옷\n 1번옷 2번옷"
        clotheLabel.textAlignment = .center
        clotheLabel.numberOfLines = 0
        clotheLabel.backgroundColor = .systemCyan
        clotheLabel.alpha = 0.5
        clotheLabel.layer.cornerRadius = 10
        clotheLabel.clipsToBounds = true
        view.addSubview(clotheLabel)
        clotheLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clotheLabel.widthAnchor.constraint(equalToConstant: 150),
            clotheLabel.heightAnchor.constraint(equalToConstant: 150),
            clotheLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -85),
            clotheLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20)
        ])
        let accessoryLabel = UILabel()
        accessoryLabel.text = "(추가)악세사리\n 1번악세사리 2번악세사리"
        accessoryLabel.textAlignment = .center
        accessoryLabel.numberOfLines = 0
        accessoryLabel.backgroundColor = .systemCyan
        accessoryLabel.alpha = 0.5
        accessoryLabel.layer.cornerRadius = 10
        accessoryLabel.clipsToBounds = true
        view.addSubview(accessoryLabel)
        accessoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accessoryLabel.widthAnchor.constraint(equalToConstant: 150),
            accessoryLabel.heightAnchor.constraint(equalToConstant: 150),
            accessoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 85),
            accessoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20)

        ])
        let likeButton = UIButton()
        likeButton.setTitle("만족스러워요", for: .normal)
        likeButton.setTitleColor(.systemBackground, for: .normal)
        likeButton.backgroundColor = .systemGray
        likeButton.layer.cornerRadius = 50
        view.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -70),
            likeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 100),
            likeButton.heightAnchor.constraint(equalToConstant: 100)
        ])
        let hateButton = UIButton()
        hateButton.setTitle("별로에요", for: .normal)
        hateButton.setTitleColor(.systemBackground, for: .normal)
        hateButton.backgroundColor = .systemGray
        hateButton.layer.cornerRadius = 50
        view.addSubview(hateButton)
        hateButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 70),
            hateButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            hateButton.widthAnchor.constraint(equalToConstant: 100),
            hateButton.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

}
