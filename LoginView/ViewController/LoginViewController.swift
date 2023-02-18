//
//  LoginViewController.swift
//  FindParkingLot
//
//  Created by 김재동 on 2023/02/14.
//

import UIKit
import SnapKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 25
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var parkingIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "parkingsign.circle.fill"))
        
        imageView.contentMode = .scaleAspectFit
        imageView.frame.size = CGSize(width: 50, height: 50)        
        
        return imageView
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        
        label.text = "회원가입하여 주변 주차장 찾기!"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    private lazy var loginStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 25
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var emailLoginButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        
        button.setTitle("이메일/비밀번호로 계속하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 50, bottom: 5, right: 50)
        
        button.backgroundColor = .gray
        
        button.addTarget(self, action: #selector(emailLoginButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var googleLoginButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        
        button.setTitle("Google로 계속하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        
        button.setImage(UIImage(named: "logo_google"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -50, bottom: 0, right: 0)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 55, bottom: 5, right: 55)
        
        button.backgroundColor = .gray
        
        button.addTarget(self, action: #selector(googleLoginButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var appleLoginButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        
        button.setTitle("Apple로 계속하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        
        button.setImage(UIImage(named: "logo_apple"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -60, bottom: 0, right: 0)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 60, bottom: 5, right: 60)
        
        button.backgroundColor = .gray
        
        return button
    }()
    
    @objc
    private func emailLoginButtonTapped() {
        let emailViewController = EmailViewController()

        self.navigationController?.pushViewController(emailViewController, animated: true)
    }
    
    @objc
    private func googleLoginButtonTapped() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "error")
                return
            }
            
            guard let signInResult = signInResult else { return }

            let user = signInResult.user

            let emailAddress = user.profile?.email

            let fullName = user.profile?.name
            let givenName = user.profile?.givenName
            let familyName = user.profile?.familyName

            let profilePicUrl = user.profile?.imageURL(withDimension: 320)
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = .black
        navigationController?.navigationBar.isHidden = true
    }
    
    private func attribute() {

    }
    
    private func layout() {
        [
            parkingIcon,
            loginLabel
        ].forEach { infoStackView.addArrangedSubview($0) }
        
        [
            emailLoginButton,
            googleLoginButton,
            appleLoginButton
        ].forEach { loginStackView.addArrangedSubview($0) }
        
        [
            infoStackView,
            loginStackView
        ].forEach { view.addSubview($0) }
        
        infoStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(300)
            $0.leading.equalToSuperview().offset(50)
        }
        
        loginStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(infoStackView.snp.bottom).offset(70)
            $0.leading.equalTo(infoStackView)
        }
    }
}
