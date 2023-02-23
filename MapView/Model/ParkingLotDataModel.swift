//
//  ParkingLotDataModel.swift
//  FindParkingLot
//
//  Created by 김재동 on 2023/02/20.
//

import Foundation

struct item: Decodable {
    let name: String
    let type: String
    let address: String
    let phoneNumber: String
    let lat: String
    let lng: String
    
    enum CodingKeys: String, CodingKey {
        case name = "prkplceNm"
        case type = "prkplceSe"
        case address = "rdnmadr"
        case phoneNumber
        case lat = "latitude"
        case lng = "longitude"
    }
}

struct items: Decodable {
    let all: [item]
    let totalCount: String
    
    enum CodingKeys: String, CodingKey {
        case all = "items"
        case totalCount
    }
}

struct body: Decodable {
    let all: items
    
    enum CodingKeys: String, CodingKey {
        case all = "body"
    }
}

struct ParkingLotDataModel: Decodable {
    let all: body
    
    enum CodingKeys: String, CodingKey {
        case all = "response"
    }
}
