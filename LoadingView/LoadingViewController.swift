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
    var currentItem = item(name: "", type: "", address: "", phoneNumber: "", lat: "", lng: "")
    
    private let xmlParser = XMLParser()
    private var currentElement = ""
    
    private let serviceKey = "vriVsoVANzAPR4GWiHqTmd5PhcEuOswMLcSIytT9pQQs4mVeRjivO%2FlnmIZFacxbC3yDvy9a3rWR0%2B8J%2FOb1GA%3D%3D"
    private let numOfRows = 14801
    
    private lazy var LoadingIndicatorView: UIActivityIndicatorView = {
        let IndicatorView = UIActivityIndicatorView(style: .large)
        
        return IndicatorView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor(named: "LoadingView")
        view.addSubview(LoadingIndicatorView)
        
        layout()
        requestParkingLotData()
    }
}

extension LoadingViewController {
    private func layout() {
        LoadingIndicatorView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(300)
            $0.centerX.equalToSuperview()
        }
        
        LoadingIndicatorView.startAnimating()
    }
    
    private func requestParkingLotData() {
        let url = "http://api.data.go.kr/openapi/tn_pubr_prkplce_info_api?serviceKey=\(serviceKey)&pageNo=0&numOfRows=\(numOfRows)&type=xml"
        
        guard let xmlParser = XMLParser(contentsOf: URL(string: url)!) else { return }
        
        xmlParser.delegate = self;
        xmlParser.parse()
    }
    
    private func showLoginViewController() {
        let LoginViewController = LoginViewController()
        self.navigationController?.pushViewController(LoginViewController, animated: true)
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
        case "phoneNumber": currentItem.phoneNumber = string
            break
        case "latitude": currentItem.lat = string
            break
        case "longitude": currentItem.lng = string
            break
        default:
            break
        }
    }
}
