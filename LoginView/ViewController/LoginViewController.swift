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
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class LoginViewController: UIViewController {
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 25
        stackView.alignment = .center
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var parkingIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo_parkingLot"))
        
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        return imageView
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        
        label.text = "회원가입하여 주변 주차장을 찾으세요!"
        label.numberOfLines = 0
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
        var config = UIButton.Configuration.filled()
        
        config.background.strokeWidth = 1
        config.background.strokeColor = .white
        config.background.cornerRadius = 15
        
        config.background.backgroundColor = .gray
        
        config.title = "이메일/비밀번호로 계속하기"
        config.attributedTitle?.font = .systemFont(ofSize: 15, weight: .bold)
        config.attributedTitle?.foregroundColor = .white
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 50, bottom: 5, trailing: 50)
        
        button.configuration = config
        button.addTarget(self, action: #selector(emailLoginButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var googleLoginButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        
        config.background.strokeWidth = 1
        config.background.strokeColor = .white
        config.background.cornerRadius = 15
        
        config.background.backgroundColor = .gray
        
        config.title = "Google로 계속하기"
        config.attributedTitle?.font = .systemFont(ofSize: 15, weight: .bold)
        config.attributedTitle?.foregroundColor = .white
        
        config.image = UIImage(named: "logo_google")
        
        config.imagePadding = 30
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 30, bottom: 5, trailing: 50)
        
        button.configuration = config
        button.addTarget(self, action: #selector(googleLoginButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var kakaoLoginButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        
        config.background.strokeWidth = 1
        config.background.strokeColor = .white
        config.background.cornerRadius = 15
        
        config.background.backgroundColor = .gray
        
        config.title = "Kakao로 계속하기"
        config.attributedTitle?.font = .systemFont(ofSize: 15, weight: .bold)
        config.attributedTitle?.foregroundColor = .white
        
        config.image = UIImage(named: "logo_kakaoTalk")
        
        config.imagePadding = 35
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 31, bottom: 5, trailing: 55)
        
        button.configuration = config
        button.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = .black
        navigationController?.navigationBar.isHidden = true
    }
}

extension LoginViewController {
    @objc
    private func emailLoginButtonTapped() {
        self.showEmailViewController()
    }
    
    @objc
    private func googleLoginButtonTapped() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "error")
                return
            }
            
//            guard let signInResult = signInResult else { return }

//            let user = signInResult.user
//
//            let emailAddress = user.profile?.email
//
//            let fullName = user.profile?.name
//            let givenName = user.profile?.givenName
//            let familyName = user.profile?.familyName
//
//            let profilePicUrl = user.profile?.imageURL(withDimension: 320)
            
            self.showMapViewController()
        }
    }
    
    @objc
    private func kakaoLoginButtonTapped() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
                    _ = oauthToken
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
               if let error = error {
                 print(error)
               }
               else {
                print("loginWithKakaoAccount() success.")
                
                //do something
                _ = oauthToken
               }
            }
        }
    }
    
    private func showEmailViewController() {
        let emailViewController = EmailViewController()
        self.navigationController?.pushViewController(emailViewController, animated: true)
    }
    
    private func showMapViewController() {
        let mapViewController = MapViewController()
        self.navigationController?.pushViewController(mapViewController, animated: true)
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
            kakaoLoginButton
        ].forEach { loginStackView.addArrangedSubview($0) }
        
        [
            infoStackView,
            loginStackView
        ].forEach { view.addSubview($0) }
        
        infoStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(150)
            $0.leading.equalToSuperview().offset(0)
        }
        
        loginStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(infoStackView.snp.bottom).offset(50)
            $0.leading.equalTo(infoStackView)
        }
    }
}
