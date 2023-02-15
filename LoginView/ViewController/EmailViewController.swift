//
//  EmailViewController.swift
//  FindParkingLot
//
//  Created by 김재동 on 2023/02/14.
//

import UIKit
import FirebaseAuth
import SnapKit

class EmailViewController: UIViewController {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 25
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        
        label.text = "이메일 주소가 무엇인가요?"
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    private lazy var emailTextFiled: UITextField = {
        let textField = UITextField()
        
        textField.keyboardType = .emailAddress
        
        textField.delegate = self
        textField.becomeFirstResponder()
        textField.backgroundColor = .white
        
        textField.font = .systemFont(ofSize: 25, weight: .regular)
        textField.textColor = .black
        
        return textField
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        
        label.text = "비밀번호를 입력해주세요."
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    private lazy var passwordTextFiled: UITextField = {
        let textField = UITextField()
        
        textField.delegate = self
        textField.backgroundColor = .white
        
        textField.font = .systemFont(ofSize: 25, weight: .regular)
        textField.textColor = .black
        
        return textField
    }()
    
    private lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        button.isEnabled = false
        
        button.backgroundColor = .white
        
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = .black
        navigationController?.navigationBar.isHidden = false
    }
    
    func bind(_ viewModel: EmailViewModel) {
        
    }
    
    private func attribute() {

    }
    
    private func layout() {
        [
            emailLabel,
            emailTextFiled,
            passwordLabel,
            passwordTextFiled
        ].forEach { stackView.addArrangedSubview($0) }
        
        [
            stackView,
            nextButton
        ].forEach { view.addSubview($0) }
        
        emailTextFiled.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        passwordTextFiled.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(150)
            $0.leading.equalToSuperview().offset(25)
        }
        
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(stackView.snp.bottom).offset(100)
        }
    }
}

extension EmailViewController: UITextFieldDelegate {
    
}
