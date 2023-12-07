//
//  ManageSubjectGroupM.swift
//  MrS-Cool
//
//  Created by wecancity on 07/12/2023.
//

import Foundation

// MARK: - SubjectGroupM
struct SubjectGroupM: Codable {
    var id, teacherSubjectAcademicSemesterYearID: Int?
    var teacherSubjectAcademicSemesterYearName, groupName, startDate, endDate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case teacherSubjectAcademicSemesterYearID = "teacherSubjectAcademicSemesterYearId"
        case teacherSubjectAcademicSemesterYearName, groupName, startDate, endDate
    }
}

// MARK: - SubjectGroupDetailsM -
struct SubjectGroupDetailsM: Codable {
    var id, teacherSubjectAcademicSemesterYearID: Int?
    var teacherSubjectAcademicSemesterYearName, groupName, startDate, endDate: String?
    var numLessons: Int?
    var scheduleSlots: [ScheduleSlot]?

    enum CodingKeys: String, CodingKey {
        case id
        case teacherSubjectAcademicSemesterYearID = "teacherSubjectAcademicSemesterYearId"
        case teacherSubjectAcademicSemesterYearName, groupName, startDate, endDate, numLessons, scheduleSlots
    }
}

// MARK: - ScheduleSlot -
struct ScheduleSlot: Codable {
    var dayID: Int?
    var timeFrom, timeTo, dayName, lessonName: String?
    var teacherLessonID: Int?
    var date: String?

    enum CodingKeys: String, CodingKey {
        case dayID = "dayId"
        case timeFrom, timeTo, dayName, lessonName
        case teacherLessonID = "teacherLessonId"
        case date
    }
}



// MARK: - SubjectGroupDeleteM -
struct SubjectGroupDeleteM: Codable {
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
