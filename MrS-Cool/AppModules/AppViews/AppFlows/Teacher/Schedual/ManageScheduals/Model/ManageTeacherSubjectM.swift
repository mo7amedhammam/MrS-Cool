//
//  ManageTeacherSubjectM.swift
//  MrS-Cool
//
//  Created by wecancity on 28/11/2023.
//

import Foundation

// MARK: - TeacherSchedualM -
struct TeacherSchedualM: Codable, Hashable {
    var dayID: Int?
    var fromStartDate, toEndDate, fromTime, toTime: String?
    var id, teacherID: Int?
    var dayName: String?

    enum CodingKeys: String, CodingKey {
        case dayID = "dayId"
        case fromStartDate, toEndDate, fromTime, toTime, id
        case teacherID = "teacherId"
        case dayName
    }
}

