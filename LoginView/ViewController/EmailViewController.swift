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
    let parkingLots: [item]
    
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
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        
        textField.keyboardType = .emailAddress
        
        textField.delegate = self
        textField.becomeFirstResponder()
        textField.backgroundColor = .white
        
        textField.font = .systemFont(ofSize: 20, weight: .regular)
        textField.textColor = .black
        
        textField.borderStyle = .roundedRect
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        textField.addTarget(self, action: #selector(checkEmailAndPassword), for: .editingChanged)
        
        return textField
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        
        label.text = "비밀번호를 입력해주세요."
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        
        textField.isSecureTextEntry = true
        
        textField.delegate = self
        textField.backgroundColor = .white
        
        textField.font = .systemFont(ofSize: 20, weight: .regular)
        textField.textColor = .black
        
        textField.borderStyle = .roundedRect
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        textField.addTarget(self, action: #selector(checkEmailAndPassword), for: .editingChanged)
        
        return textField
    }()
    
    private lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .red
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        
        config.background.backgroundColor = .white
        
        config.title = "다음"
        config.attributedTitle?.font = .systemFont(ofSize: 20, weight: .bold)
        config.attributedTitle?.foregroundColor = .gray
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        button.configuration = config
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    @objc
    private func nextButtonTapped() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                let code = (error as NSError).code
                switch code {
                case 17007: //이미 가입한 계정
                    self.loginUser(withEmail: email, password: password)
                default:
                    self.errorMessageLabel.text = error.localizedDescription
                }
            } else {
                self.showMapViewController()
            }
            
        }
    }
    
    private func loginUser(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessageLabel.text = error.localizedDescription
            } else {
                self.showMapViewController()
            }
        }
    }
    
    private func showMapViewController() {
        let mapViewController = MapViewController(parkingLots: parkingLots)
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    init(parkingLots: [item]) {
        self.parkingLots = parkingLots
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = .white
        
        navigationItem.title = "이메일로 계속하기"
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = true
        
        attribute()
        layout()
    }
    
    func bind(_ viewModel: EmailViewModel) {
        
    }
    
    private func attribute() {

    }
    
    private func layout() {
        [
            emailLabel,
            emailTextField,
            passwordLabel,
            passwordTextField,
            errorMessageLabel
        ].forEach { stackView.addArrangedSubview($0) }
        
        [
            stackView,
            nextButton
        ].forEach { view.addSubview($0) }
        
        emailTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        passwordTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        errorMessageLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(125)
            $0.leading.equalToSuperview().offset(25)
        }
        
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(stackView.snp.bottom).offset(25)
        }
    }
}

extension EmailViewController: UITextFieldDelegate {
    @objc private func checkEmailAndPassword() {
        let isEmailEmpty = emailTextField.text == ""
        let isPasswordEmpty = passwordTextField.text == ""
        
        nextButton.isEnabled = !isEmailEmpty && !isPasswordEmpty
        
        if(nextButton.isEnabled) {
            nextButton.configuration?.attributedTitle?.foregroundColor = .black
        } else {
            nextButton.configuration?.attributedTitle?.foregroundColor = .gray
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkEmailAndPassword()
        return true
    }
}
