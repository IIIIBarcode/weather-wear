//
//  ViewController.swift
//  WeatherWear
//
//  Created by t2023-m079 on 2023/09/25.
//

import UIKit

class ViewController: UIViewController {
    lazy var btn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        btn.setTitle("피드백페이지이동", for: .normal)
        btn.backgroundColor = .yellow
        btn.setTitleColor(.black, for: .normal)
        view.addSubview(btn)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        makeUi()
    }

    func makeUi() {
        btn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            btn.widthAnchor.constraint(equalToConstant: 50),
            btn.heightAnchor.constraint(equalToConstant: 70)
        ])
    }

    @objc func clickBtn() {
//        guard let feedbackViewController = self.storyboard?.instantiateViewController(withIdentifier: "Feedback") else {return}
        let feedbackViewController = FeedbackViewController()
        self.navigationController?.pushViewController(feedbackViewController, animated: true)
    }
}
