//
//  ParkingLotDataModel.swift
//  FindParkingLot
//
//  Created by 김재동 on 2023/02/20.
//

import Foundation

struct item: Decodable {
//    let name: String
//    let type: String
//    let address: String
//    let phoneNumber: String
//    let lat: String
//    let lng: String
    var name: String
    var type: String
    var address: String
    var phoneNumber: String
    var lat: String
    var lng: String
    
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
