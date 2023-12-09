//
//  ManageSubjectGroupM.swift
//  MrS-Cool
//
//  Created by wecancity on 07/12/2023.
//

import Foundation


// MARK: - SubjectGroupM
struct SubjectGroupM: Codable,Hashable {
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

// MARK: - SubjectGroupDetailsM To Diction-
// convert that model to dictionary to be sendable parameters -
extension SubjectGroupDetailsM {
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]

        dictionary["id"] = id
        dictionary["teacherSubjectAcademicSemesterYearID"] = teacherSubjectAcademicSemesterYearID
        dictionary["teacherSubjectAcademicSemesterYearName"] = teacherSubjectAcademicSemesterYearName
        dictionary["groupName"] = groupName
        dictionary["startDate"] = startDate
        dictionary["endDate"] = endDate
        dictionary["numLessons"] = numLessons

        if let scheduleSlots = scheduleSlots {
            let scheduleSlotsArray = scheduleSlots.map { $0.toDictionary() }
            dictionary["scheduleSlots"] = scheduleSlotsArray
        }

        return dictionary
    }
}

// MARK: - SubjectGroupDetailsM To Diction-
// convert that model to dictionary to be sendable parameters -
extension ScheduleSlot {
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]

        dictionary["dayId"] = dayID
        dictionary["timeFrom"] = timeFrom
        dictionary["timeTo"] = timeTo
        dictionary["dayName"] = dayName
        dictionary["lessonName"] = lessonName
        dictionary["teacherLessonId"] = teacherLessonID
        dictionary["date"] = date

        return dictionary
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

struct NewScheduleSlotsM: Hashable{
    var day: DropDownOption?
    var fromTime: String?
    enum CodingKeys: String, CodingKey {
        case day
        case fromTime
    }
}
struct CreateScheduleSlotsM{
    var dayId: Int?
    var fromTime: String?
    enum CodingKeys: String, CodingKey {
        case dayId
        case fromTime
    }
}


// convert that model to dictionary to be sendable parameters -
//extension CreateScheduleSlotsM {
//    func toDictionary() -> [String: Any] {
//        var dictionary: [String: Any] = [:]
//        if let dayId = day?.id {
//            dictionary["dayId"] = dayId
//        }
//        dictionary["fromTime"] = fromTime
//
//        return dictionary
//    }
//}
