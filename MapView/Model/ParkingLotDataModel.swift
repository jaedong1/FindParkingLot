//
//  ParkingLotDataModel.swift
//  FindParkingLot
//
//  Created by 김재동 on 2023/02/20.
//

import Foundation

struct item: Decodable {
    var name: String
    var type: String
    var address: String
    var lat: String
    var lng: String
    var isFree: String
    var basicTime: String
    var basicCharge: String
    var addUnitTime: String
    var addUnitCharge: String
    
    enum CodingKeys: String, CodingKey {
        case name = "prkplceNm"
        case type = "prkplceSe"
        case address = "rdnmadr"
        case lat = "latitude"
        case lng = "longitude"
        case isFree = "parkingchrgeInfo"
        case basicTime, basicCharge, addUnitTime, addUnitCharge
    }
    
    init() {
        name = ""
        type = ""
        address = ""
        lat = ""
        lng = ""
        isFree = ""
        basicTime = ""
        basicCharge = ""
        addUnitTime = ""
        addUnitCharge = ""
    }
}

struct items: Decodable {
    let items: [item]
    let totalCount: String
    
    enum CodingKeys: String, CodingKey {
        case items
        case totalCount
    }
}

struct body: Decodable {
    let body: items
    
    enum CodingKeys: String, CodingKey {
        case body
    }
}

struct ParkingLotDataModel: Decodable {
    let response: body
    
    enum CodingKeys: String, CodingKey {
        case response
    }
}
