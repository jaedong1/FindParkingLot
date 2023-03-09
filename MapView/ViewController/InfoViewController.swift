//
//  InfoViewController.swift
//  FindParkingLot
//
//  Created by 김재동 on 2023/03/07.
//

import UIKit
import SnapKit

class InfoViewController: UIViewController {
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        
        config.background.backgroundColor = .clear
        
        config.title = "닫기"
        config.attributedTitle?.font = .systemFont(ofSize: 15, weight: .semibold)
        config.attributedTitle?.foregroundColor = .systemBlue
        
        button.configuration = config
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        
        return label
    }()
    
    private lazy var imageStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var typeImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "ellipsis.circle")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal))
        
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        return imageView
    }()
    
    private lazy var addressImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "map")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal))
        
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        return imageView
    }()
    
    private lazy var priceImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "wonsign")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal))
        
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        return imageView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .regular)
        
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .regular)
        
        return label
    }()
    
    private lazy var isFreeLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .regular)
        
        return label
    }()
    
    private lazy var basicTimeLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .regular)
        
        return label
    }()
    
    private lazy var basicChargeLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .regular)
        
        return label
    }()
    
    private lazy var addUnitTimeLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .regular)
        
        return label
    }()
    
    private lazy var addUnitChargeLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .regular)
        
        return label
    }()
    
    init(parkingLot: item?) {
        super.init(nibName: nil, bundle: nil)
        
        guard let parkingLot = parkingLot else { return }
        
        nameLabel.text = MapViewController.parkingLotRename(parkingLot: parkingLot)
        typeLabel.text = parkingLot.type
        addressLabel.text = parkingLot.address
        isFreeLabel.text = parkingLot.isFree
        
        if isFreeLabel.text != "무료" {
            basicTimeLabel.text = "주차 기본 시간 : " + parkingLot.basicTime + "분"
            basicChargeLabel.text = "주차 기본 요금 : " + parkingLot.basicCharge + "원"
            addUnitTimeLabel.text = "추가 단위 시간 : " + parkingLot.addUnitTime + "분"
            addUnitChargeLabel.text = "추가 단위 요금 : " + parkingLot.addUnitCharge + "원"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        layout()
    }
}

extension InfoViewController {
    func dismiss() {
        dismiss(animated: true)
        MapViewController.setCameraCenter(bottom: 0)
    }
    
    @objc
    private func dismissButtonTapped() {
        dismiss()
    }
    
    private func layout() {
        [
            typeImage,
            addressImage,
            priceImage
        ].forEach { imageStackView.addArrangedSubview($0) }
        
        [
            typeLabel,
            addressLabel,
            isFreeLabel,
            basicTimeLabel,
            basicChargeLabel,
            addUnitTimeLabel,
            addUnitChargeLabel
        ].forEach { labelStackView.addArrangedSubview($0) }
        
        [
            dismissButton,
            nameLabel,
            imageStackView,
            labelStackView
        ].forEach { view.addSubview($0) }
        
        dismissButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(15)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dismissButton.snp.bottom).offset(10)
        }
        
        imageStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(25)
            $0.top.equalTo(nameLabel.snp.bottom).offset(50)
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalTo(imageStackView.snp.trailing).offset(15)
            $0.top.equalTo(imageStackView.snp.top)
        }
    }
}
