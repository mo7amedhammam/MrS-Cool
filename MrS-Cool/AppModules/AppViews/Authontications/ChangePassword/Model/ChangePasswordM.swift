//
//  ChangePasswordM.swift
//  MrS-Cool
//
//  Created by wecancity on 16/11/2023.
//

// MARK: - ChangePasswordM -
struct ChangePasswordM: Codable {
    var name, email, birthdate: String?
    var cityID, genderID, id: Int?
    var code, creationDate: String?

    enum CodingKeys: String, CodingKey {
        case name, email, birthdate
        case cityID = "cityId"
        case genderID = "genderId"
        case id, code, creationDate
    }
}
