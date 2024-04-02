//
//  ParentProfileM.swift
//  MrS-Cool
//
//  Created by wecancity on 02/04/2024.
//

import Foundation


// MARK: - ParentProfileM
struct ParentProfileM: Codable {
    var name, email, birthdate: String?
    var cityID, genderID, id: Int?
    var code, creationDate, mobile: String?
    var countryID, governoratedID: Int?
    var countryName, governorateName, cityName, genderName: String?
    var image: String?

    enum CodingKeys: String, CodingKey {
        case name, email, birthdate
        case cityID = "cityId"
        case genderID = "genderId"
        case id, code, creationDate, mobile
        case countryID = "countryId"
        case governoratedID = "governoratedId"
        case countryName, governorateName, cityName, genderName, image
    }
}
