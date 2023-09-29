//
//  ItemTableViewCell.swift
//  WeatherWear
//
//  Created by t2023-m079 on 2023/09/27.
//

import UIKit
import SnapKit

class ItemTableViewCell: UITableViewCell {
    lazy var numberingLabel: UILabel = {
        let label = UILabel()
        label.text = "a."
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        contentView.addSubview(label)
        return label
    }()
    
    lazy var itemLabel: UILabel = {
        let label = UILabel()
        label.text = "반팔, 얇은 셔츠\n 반바지, 면바지"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        let attrString = NSMutableAttributedString(string: label.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        label.attributedText = attrString
        label.layer.cornerRadius = 20
        label.textAlignment = .center
        label.layer.backgroundColor = UIColor.separator.cgColor
        contentView.addSubview(label)
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            itemLabel.layer.backgroundColor = UIColor.white.cgColor
            itemLabel.textColor = .black
        }
        
        else {
            itemLabel.layer.backgroundColor = UIColor.separator.cgColor
            itemLabel.textColor = .white
        }

        // Configure the view for the selected state
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        numberingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.leading.equalTo(self.contentView.snp.leading)
        }
        itemLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(10)
            make.bottom.equalTo(contentView.snp.bottom).inset(10)
            make.leading.equalTo(numberingLabel.snp.trailing).offset(30)
            make.trailing.equalTo(contentView.snp.trailing)
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
