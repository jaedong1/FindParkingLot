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
    
    private lazy var stackView: UIStackView = {
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
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        
        return label
    }()
    
    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        layout()
    }
    
    init(parkingLot: item?, mapViewController: MapViewController?) {
        super.init(nibName: nil, bundle: nil)
        
        nameLabel.text = mapViewController?.parkingLotRename(parkingLot: parkingLot) ?? ""
        typeLabel.text = parkingLot?.type
        addressLabel.text = parkingLot?.address
        phoneNumberLabel.text = parkingLot?.phoneNumber
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InfoViewController {
    @objc
    private func dismissButtonTapped() {
        dismiss()
    }
    
    private func layout() {
        [
            typeLabel,
            addressLabel,
            phoneNumberLabel
        ].forEach { stackView.addArrangedSubview($0) }
        
        [
            dismissButton,
            nameLabel,
            stackView
        ].forEach { view.addSubview($0) }
        
        dismissButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(15)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dismissButton.snp.bottom)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(25)
            $0.top.equalTo(nameLabel.snp.bottom).offset(100)
        }
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
}
