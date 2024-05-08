//
//  ManageTeacherSubjectsM.swift
//  MrS-Cool
//
//  Created by wecancity on 14/11/2023.
//

import Foundation
// MARK: - ManageTeacherSubjectsM -
//struct ManageTeacherSubjectsM: Codable {
//    var subjectAcademicYearID: Int?
//    var groupCost, individualCost: Float?
//    var maxGroup, minGroup: Int?
//    var teacherBrief: String?
//    var statusID, id: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case subjectAcademicYearID = "subjectSemesterYearId"
//        case groupCost, individualCost, minGroup, maxGroup, teacherBrief
//        case statusID = "statusId"
//        case id
//    }
//}



// MARK: - ManageTeacherSubjectsM -
struct ManageTeacherSubjectsM: Codable {
    var groupCost, individualCost, minGroup, maxGroup: Int?
    var statusID, id: Int?
    var educationTypeName, educationLevelName, academicYearName, subjectSemesterYearName: String?
    var subjectDisplayName: String?
    var educationTypeID, educationLevelID, academicYearID: Int?
    var statusIDName, brief, teacherBrief, teacherBriefEn: String?

    enum CodingKeys: String, CodingKey {
        case groupCost, individualCost, minGroup, maxGroup
        case statusID = "statusId"
        case id, educationTypeName, educationLevelName, academicYearName, subjectSemesterYearName, subjectDisplayName
        case educationTypeID = "educationTypeId"
        case educationLevelID = "educationLevelId"
        case academicYearID = "academicYearId"
        case statusIDName = "statusIdName"
        case brief, teacherBrief, teacherBriefEn
    }
}
