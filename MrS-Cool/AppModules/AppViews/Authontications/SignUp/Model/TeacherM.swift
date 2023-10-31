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

// MARK: - TeacherModel -
struct TeacherModel: Codable {
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
// MARK: - CreatedTeacherSubjectM -
struct CreatedTeacherSubjectM: Codable {
    var subjectAcademicYearID, groupCost, individualCost, minGroup: Int?
    var maxGroup: Int?
    var teacherBrief: String?
    var statusID, id, teacherID: Int?
    var creationDate: String?
    var verifiedByID: Int?
    var verifiedAt: String?

    enum CodingKeys: String, CodingKey {
        case subjectAcademicYearID = "subjectAcademicYearId"
        case groupCost, individualCost, minGroup, maxGroup, teacherBrief
        case statusID = "statusId"
        case id
        case teacherID = "teacherId"
        case creationDate
        case verifiedByID = "verifiedById"
        case verifiedAt
    }
}

// MARK: - TeacherSubjectM -
struct TeacherSubjectM: Codable,Hashable {
    var subjectAcademicYearID, groupCost, individualCost, minGroup: Int?
    var maxGroup: Int?
    var teacherBrief: String?
    var statusID, id: Int?
    var educationTypeName, educationLevelName, academicYearName, subjectSemesterYearName: String?
    var subjectDisplayName: String?
    var educationTypeID, educationLevelID, subjectSemesterID: Int?
    var statusIDName: String?

    enum CodingKeys: String, CodingKey {
        case subjectAcademicYearID = "subjectAcademicYearId"
        case groupCost, individualCost, minGroup, maxGroup, teacherBrief
        case statusID = "statusId"
        case id, educationTypeName, educationLevelName, academicYearName, subjectSemesterYearName, subjectDisplayName
        case educationTypeID = "educationTypeId"
        case educationLevelID = "educationLevelId"
        case subjectSemesterID = "subjectSemesterId"
        case statusIDName = "statusIdName"
    }
}


//MARK: -- Teacher Documents --

// MARK: - TeacherDocumentM
struct TeacherDocumentM: Codable,Hashable {
    var documentTypeID: Int?
    var title: String?
    var order, id, teacherID: Int?
    var documentPath, documentTypeName, creationDate: String?

    enum CodingKeys: String, CodingKey {
        case documentTypeID = "documentTypeId"
        case title, order, id
        case teacherID = "teacherId"
        case documentPath, documentTypeName, creationDate
    }
}
