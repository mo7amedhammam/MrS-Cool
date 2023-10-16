//
//  SignInModel.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import Foundation

// MARK: - SignInModel
struct SignInModel: Codable{
    var name, mobile: String?
    var genderID, districtID: Int?
    var address, pharmacyCode: String?
    var id: Int?
    var code, genderTitle, token: String?
    
    enum CodingKeys: String, CodingKey {
        case name, mobile
        case genderID = "genderId"
        case districtID = "districtId"
        case address, pharmacyCode, id, code, genderTitle, token
    }
}
