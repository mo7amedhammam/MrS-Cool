//
//  TeacherM.swift
//  MrS-Cool
//
//  Created by wecancity on 25/10/2023.
//

import Foundation

// MARK: -- Teacher Data  --
/// OtopM
struct OtpM: Codable ,Equatable{
    var otp, secondsCount: Int?
}

//// MARK: -- send teacher otp Response  --
//struct OTPTeacherM: Codable {
//    var otp, mobile: Int?
//}

// MARK: - TeacherDataM -
struct TeacherDataM: Codable {
    var id: Int?
    var token, email, name, mobile: String?
    var imagePath, role: String?
    var roleID, profileStatusID: Int?

    enum CodingKeys: String, CodingKey {
        case id, token, email, name, mobile, imagePath, role
        case roleID = "roleId"
        case profileStatusID = "profileStatusId"
    }
}
