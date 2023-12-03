//
//  GroupForLessonM.swift
//  MrS-Cool
//
//  Created by wecancity on 02/12/2023.
//

import Foundation

// MARK: - GroupForLessonM -
struct GroupForLessonM: Codable, Hashable {
    var id: Int?
    var lessonName, groupName, date,timeFrom, timeTo: String?
    var teacherSubjectAcademicSemesterYearName: String?

    enum CodingKeys: String, CodingKey {
        case lessonName, groupName,date, timeFrom, timeTo, id
        case teacherSubjectAcademicSemesterYearName
    }
}
