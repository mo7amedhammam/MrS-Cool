//
//  LookupsModels.swift
//  MrS-Cool
//
//  Created by wecancity on 22/10/2023.
//

import Foundation

// MARK: - GendersM - Countries
struct GendersM: Codable {
    var id: Int?
    var name: String?
}

// MARK: - GovernorateM
struct GovernorateM: Codable {
    var name: String?
    var countryID, id: Int?
    var countryName: String?

    enum CodingKeys: String, CodingKey {
        case name
        case countryID = "countryId"
        case id, countryName
    }
}

// MARK: - CityM
struct CityM: Codable {
    var name: String?
    var governorateID, id: Int?
    var governorateName: String?

    enum CodingKeys: String, CodingKey {
        case name
        case governorateID = "governorateId"
        case id, governorateName
    }
}

