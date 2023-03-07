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
    let parkingLots: [item]
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var parkingIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo_parkingLot"))
        
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        return imageView
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        
        label.text = "간편 로그인"
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.text = "자주 사용하는 아이디로 간편하게 주차장 찾기 서비스에 가입하실 수 있습니다."
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .regular)
        
        label.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        return label
    }()
    
    private lazy var loginStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var emailLoginButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        
        config.background.cornerRadius = 10
        config.background.backgroundColor = .lightGray
        
        config.title = "이메일로 계속하기"
        config.attributedTitle?.font = .systemFont(ofSize: 15, weight: .regular)
        config.attributedTitle?.foregroundColor = .black
        
        config.image = UIImage(systemName: "envelope.fill")
        
        config.imagePadding = 60
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 77)
        
        button.configuration = config
        
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.3
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        button.widthAnchor.constraint(equalToConstant: 300).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        button.addTarget(self, action: #selector(emailLoginButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var googleLoginButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        
        config.background.cornerRadius = 10
        config.background.backgroundColor = .white
        
        config.title = "Google 계속하기"
        config.attributedTitle?.font = .systemFont(ofSize: 15, weight: .regular)
        config.attributedTitle?.foregroundColor = .black
        
        config.image = UIImage(named: "logo_google")
        
        config.imagePadding = 66
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 74)
        
        button.configuration = config
        
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.3
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        button.widthAnchor.constraint(equalToConstant: 300).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        button.addTarget(self, action: #selector(googleLoginButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var kakaoLoginButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()

        config.background.cornerRadius = 10
        config.background.backgroundColor = UIColor(named: "KakaoLoginButton")

        config.title = "카카오로 계속하기"
        config.attributedTitle?.font = .systemFont(ofSize: 15, weight: .regular)
        config.attributedTitle?.foregroundColor = .black

        config.image = UIImage(named: "logo_kakao")

        config.imagePadding = 62
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 73)

        button.configuration = config
        
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.3
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        button.widthAnchor.constraint(equalToConstant: 300).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        button.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)

        return button
    }()
    
    init(parkingLots: [item]) {
        self.parkingLots = parkingLots
        
        super.init(nibName: nil, bundle: nil)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
    }
}

extension LoginViewController {
    @objc
    private func emailLoginButtonTapped() {
        showEmailViewController()
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
                    
                    self.showMapViewController()
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
                   
                   self.showMapViewController()
               }
            }
        }
    }
    
    private func showEmailViewController() {
        let emailViewController = EmailViewController(parkingLots: parkingLots)
        navigationController?.pushViewController(emailViewController, animated: true)
    }
    
    private func showMapViewController() {
        let mapViewController = MapViewController(parkingLots: parkingLots)
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    private func attribute() {

    }
    
    private func layout() {
        [
            parkingIcon,
            loginLabel,
            descriptionLabel
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
            $0.top.equalToSuperview().offset(225)
            $0.leading.equalToSuperview()
        }
        
        loginStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(infoStackView.snp.bottom).offset(200)
            $0.leading.equalTo(infoStackView)
        }
    }
}
