//
//  TableViewCell.swift
//  WeatherWear
//
//  Created by 정기현 on 2023/09/27.
//

import SnapKit
import UIKit
class WeeklyTableViewCell: UITableViewCell {
    lazy var weekDate: UILabel = {
        let lb = UILabel()
        lb.text = "09월 25일"
        lb.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        lb.textColor = .white
        contentView.addSubview(lb)
        return lb
    }()

    lazy var minMax: UILabel = {
        let lb = UILabel()
        lb.text = "최고 22° 최저 18°"
        lb.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lb.textColor = .white
        contentView.addSubview(lb)
        return lb
    }()

    lazy var amView: UIView = {
        let vw = UIView()
        [amWeather, am, amPercent].forEach { vw.addSubview($0) }
        contentView.addSubview(vw)
        return vw
    }()

    lazy var amWeather: UIImageView = {
        let im = UIImageView()
        im.image = UIImage(named: "rain")
        return im
    }()

    lazy var am: UIImageView = {
        let im = UIImageView()
        im.image = UIImage(named: "am")
        return im
    }()

    lazy var amPercent: UILabel = {
        let lb = UILabel()
        lb.text = "80%"
        lb.font = UIFont.systemFont(ofSize: 10, weight: .light)
        lb.textColor = .white
        return lb
    }()

    lazy var pmView: UIView = {
        let vw = UIView()
        [pmWeather, pm, pmPercent].forEach { vw.addSubview($0) }
        contentView.addSubview(vw)
        return vw
    }()

    lazy var pmWeather: UIImageView = {
        let im = UIImageView()
        im.image = UIImage(named: "rain")
        return im
    }()

    lazy var pm: UIImageView = {
        let im = UIImageView()
        im.image = UIImage(named: "pm")
        return im
    }()

    lazy var pmPercent: UILabel = {
        let lb = UILabel()
        lb.text = "30%"
        lb.font = UIFont.systemFont(ofSize: 10, weight: .light)
        lb.textColor = .white
        return lb
    }()

    lazy var wearStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [clothesView, accessoriesView])
        st.axis = .horizontal

        st.alignment = .fill
        st.distribution = .fillEqually
        st.spacing = 7
        contentView.addSubview(st)
        return st
    }()

    lazy var clothesView: UIView = {
        let vw = UIView()
        vw.addSubview(clothes)
        vw.backgroundColor = UIColor.white.withAlphaComponent(0.1)

        vw.layer.cornerRadius = 10

        return vw
    }()

    lazy var clothes: UILabel = {
        let lb = UILabel()
        lb.text = "반팔, 얇은 셔츠, 반바지, 면바지"
        lb.font = .systemFont(ofSize: 12, weight: .medium)
        lb.textColor = .white
        lb.textAlignment = .center
        lb.numberOfLines = 4
        return lb
    }()

    lazy var accessoriesView: UIView = {
        let vw = UIView()
        vw.addSubview(accessories)
        vw.backgroundColor = UIColor.white.withAlphaComponent(0.1)

        vw.layer.cornerRadius = 10

        return vw
    }()

    lazy var accessories: UILabel = {
        let lb = UILabel()
        lb.text = "우산, 우비, 레인부츠"
        lb.font = .systemFont(ofSize: 12, weight: .medium)
        lb.textColor = .white
        lb.textAlignment = .center
        lb.numberOfLines = 4
        return lb
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear

        makeUi()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WeeklyTableViewCell {
    func makeUi() {
        weekDate.snp.makeConstraints { make in
            make.leading.top.equalTo(self.contentView)
            make.height.equalTo(18)
        }
        minMax.snp.makeConstraints { make in
            make.leading.equalTo(self.weekDate)
            make.top.equalTo(weekDate.snp.bottom)
            make.height.equalTo(20)
        }
        am.snp.makeConstraints { make in
            make.leading.top.equalTo(self.amView)
            make.width.height.equalTo(13)
        }
        amWeather.snp.makeConstraints { make in
            make.leading.equalTo(am.snp.trailing)
            make.top.equalTo(self.amView).inset(5)
            make.width.height.equalTo(18)
        }
        amPercent.snp.makeConstraints { make in
            make.top.equalTo(amWeather.snp.bottom)
            make.leading.equalTo(amWeather.snp.leading)
            make.height.equalTo(13)
        }
        amView.snp.makeConstraints { make in
            make.leading.equalTo(weekDate.snp.trailing).inset(-30)
            make.top.equalTo(self.weekDate)
            make.width.height.equalTo(40)
        }
        pm.snp.makeConstraints { make in
            make.leading.top.equalTo(self.pmView)
            make.width.height.equalTo(13)
        }
        pmWeather.snp.makeConstraints { make in
            make.leading.equalTo(pm.snp.trailing)
            make.top.equalTo(self.pmView).inset(5)
            make.width.height.equalTo(18)
        }
        pmPercent.snp.makeConstraints { make in
            make.top.equalTo(pmWeather.snp.bottom)
            make.leading.equalTo(pmWeather.snp.leading)
            make.height.equalTo(13)
        }
        pmView.snp.makeConstraints { make in
            make.leading.equalTo(amView.snp.trailing).inset(-8)
            make.top.equalTo(self.weekDate)
            make.width.height.equalTo(40)
        }
        clothes.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self.clothesView)
            make.width.equalTo(100)
        }
        accessories.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self.accessoriesView)
            make.width.equalTo(100)
        }
        wearStack.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView).inset(12)
            make.top.equalTo(minMax.snp.bottom).inset(-10)
        }
    }
}
