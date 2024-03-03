//
//  StudentEditProfileM.swift
//  MrS-Cool
//
//  Created by wecancity on 03/03/2024.
//

//import Foundation


// MARK: - StudentProfileM
struct StudentProfileM: Codable {
    var name: String?
    var academicYearEducationLevelID: Int?
    var birthdate: String?
    var genderID, id: Int?
    var code: String?
    var parentsID: Int?
    var parentName, email, schoolName: String?
    var cityID, educationTypeID, educationLevelID: Int?
    var creationDate: String?
    var countryID, governorateID: Int?
    var image, mobile, countryName, governorateName: String?
    var cityName, genderName, educationLevelName, educationTypeName: String?
    var academicYearName: String?

    enum CodingKeys: String, CodingKey {
        case name
        case academicYearEducationLevelID = "academicYearEducationLevelId"
        case birthdate
        case genderID = "genderId"
        case id, code
        case parentsID = "parentsId"
        case parentName, email, schoolName
        case cityID = "cityId"
        case educationTypeID = "educationTypeId"
        case educationLevelID = "educationLevelId"
        case creationDate
        case countryID = "countryId"
        case governorateID = "governorateId"
        case image, mobile, countryName, governorateName, cityName, genderName, educationLevelName, educationTypeName, academicYearName
    }
}
