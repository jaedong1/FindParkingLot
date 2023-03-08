//
//  LoadingViewController.swift
//  FindParkingLot
//
//  Created by 김재동 on 2023/03/01.
//

import UIKit
import SnapKit
import Alamofire

class LoadingViewController: UIViewController {
    var parkingLots: [item] = []
    var currentItem = item()
    
    private let xmlParser = XMLParser()
    private var currentElement = ""
    
    private let serviceKey = "vriVsoVANzAPR4GWiHqTmd5PhcEuOswMLcSIytT9pQQs4mVeRjivO%2FlnmIZFacxbC3yDvy9a3rWR0%2B8J%2FOb1GA%3D%3D"
    private let numOfRows = 14801
    
    private lazy var LoadingIndicatorView: UIActivityIndicatorView = {
        let IndicatorView = UIActivityIndicatorView(style: .large)
        
        IndicatorView.color = .black
        
        return IndicatorView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.text = "전국 주차장 데이터 불러오는 중..."
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .regular)
        
        return label
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = .white
        
        navigationItem.title = "주변 주차장 찾기"
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = true
        
        [
            LoadingIndicatorView,
            descriptionLabel
        ].forEach { view.addSubview($0) }
        
        layout()
        requestParkingLotData()
    }
}

extension LoadingViewController {
    private func layout() {
        LoadingIndicatorView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(350)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(LoadingIndicatorView.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        LoadingIndicatorView.startAnimating()
    }
    
    private func requestParkingLotData() {
        let url = URL(string: "http://api.data.go.kr/openapi/tn_pubr_prkplce_info_api?serviceKey=\(serviceKey)&pageNo=0&numOfRows=\(numOfRows)&type=xml")!
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                print(response!)
                return
            }
            
            let xmlParser = XMLParser(data: data!)
            
            xmlParser.delegate = self;
            xmlParser.parse()
            
            DispatchQueue.main.async {
                self.showLoginViewController()
            }
        }
        dataTask.resume()
    }
    
    
    private func showLoginViewController() {
        let LoginViewController = LoginViewController(parkingLots: parkingLots)
        navigationController?.pushViewController(LoginViewController, animated: true)
    }
}

extension LoadingViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName == "item") {
            parkingLots.append(currentItem)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "prkplceNm": currentItem.name = string
            break
        case "prkplceSe": currentItem.type = string
            break
        case "rdnmadr": currentItem.address = string
            break
        case "latitude": currentItem.lat = string
            break
        case "longitude": currentItem.lng = string
            break
        case "parkingchrgeInfo": currentItem.isFree = string
            break
        case "basicTime": currentItem.basicTime = string
            break
        case "basicCharge": currentItem.basicCharge = string
            break
        case "addUnitTime": currentItem.addUnitTime = string
            break
        case "addUnitCharge": currentItem.addUnitCharge = string
            break
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("XML Parsing error! : ", parseError)
    }
}
