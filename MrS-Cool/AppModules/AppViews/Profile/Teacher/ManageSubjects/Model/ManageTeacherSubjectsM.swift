//
//  ManageTeacherSubjectsM.swift
//  MrS-Cool
//
//  Created by wecancity on 14/11/2023.
//

import Foundation
// MARK: - ManageTeacherSubjectsM -
struct ManageTeacherSubjectsM: Codable {
    var subjectAcademicYearID, groupCost, individualCost, minGroup: Int?
    var maxGroup: Int?
    var teacherBrief: String?
    var statusID, id: Int?

    enum CodingKeys: String, CodingKey {
        case subjectAcademicYearID = "subjectAcademicYearId"
        case groupCost, individualCost, minGroup, maxGroup, teacherBrief
        case statusID = "statusId"
        case id
    }
}

