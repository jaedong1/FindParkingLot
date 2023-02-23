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

import Alamofire /***************************/

class LoginViewController: UIViewController {
    private let serviceKey = "vriVsoVANzAPR4GWiHqTmd5PhcEuOswMLcSIytT9pQQs4mVeRjivO%2FlnmIZFacxbC3yDvy9a3rWR0%2B8J%2FOb1GA%3D%3D"
    private var numOfRows = 14000
    /***************************/
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
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    private lazy var loginStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var emailLoginButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        
        config.background.cornerRadius = 5
        config.background.backgroundColor = .lightGray
        
        config.title = "이메일로 로그인"
        config.attributedTitle?.font = .systemFont(ofSize: 15, weight: .regular)
        config.attributedTitle?.foregroundColor = .black
        
        config.image = UIImage(systemName: "envelope.fill")
        
        config.imagePadding = 50
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 60)
        
        button.configuration = config
        
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.3
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        button.addTarget(self, action: #selector(emailLoginButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var googleLoginButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        
        config.background.cornerRadius = 5
        config.background.backgroundColor = .white
        
        config.title = "Google 로그인"
        config.attributedTitle?.font = .systemFont(ofSize: 15, weight: .regular)
        config.attributedTitle?.foregroundColor = .black
        
        config.image = UIImage(named: "logo_google")
        
        config.imagePadding = 52
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 62)
        
        button.configuration = config
        
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.3
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        button.addTarget(self, action: #selector(googleLoginButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var kakaoLoginButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()

        config.background.cornerRadius = 5
        config.background.backgroundColor = UIColor(named: "KakaoLoginButton")

        config.title = "카카오 로그인"
        config.attributedTitle?.font = .systemFont(ofSize: 15, weight: .regular)
        config.attributedTitle?.foregroundColor = .black

        config.image = UIImage(named: "logo_kakao")

        config.imagePadding = 55
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 66)

        button.configuration = config
        
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.3
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        let url = "http://api.data.go.kr/openapi/tn_pubr_prkplce_info_api?serviceKey=\(serviceKey)&pageNo=0&numOfRows=\(numOfRows)&type=json"
        print(url)
        
        AF.request(url)
            .validate()
            .responseDecodable(of: ParkingLotDataModel.self) { response in
                guard case .success(let data) = response.result else { return }
                print(data)
            }
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
            $0.top.equalToSuperview().offset(200)
            $0.leading.equalToSuperview().offset(0)
        }
        
        loginStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(infoStackView.snp.bottom).offset(50)
            $0.leading.equalTo(infoStackView)
        }
    }
}
